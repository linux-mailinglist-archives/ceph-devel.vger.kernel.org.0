Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0279210F565
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 04:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLCDFk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Dec 2019 22:05:40 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:35571 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbfLCDFj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 2 Dec 2019 22:05:39 -0500
Received: by mail-lj1-f181.google.com with SMTP id j6so2014482lja.2
        for <ceph-devel@vger.kernel.org>; Mon, 02 Dec 2019 19:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RmpGWLSFSFSGzHOhv4Fdj7R87ZcL3uRgxrSabqaPqQs=;
        b=BJM6pOfusE4WpyuXdJ5+Bmnl56rJivpKwPw7ZTyMeNoP2n6IFqw4Z40B88uoeWkpEH
         LFRmUKiW/pAYRHs0XGuRscJKv8mW0NLeK7r9zgzSd7El0i/+XUZibfZ3HFFzsGp/8Vnf
         nxvBWuvPWMj8X5Nhk+uSLCkLnoT3zZfeUA1oBhb7VZzOp+cQA/P2n0klODLKJhvvrZlD
         uU9mv1EioYnZ8fWyyJvQDzO+FdGDfx2L7m3zYOKGr41WSWjCnhe8kxL0WwfGzaAb0C4H
         cQlEzlPGG1MWaPYKppkdEoyWxkthVOU1W20HOmi/0b3twPXogi0T1t9Nx/vfBX0cYtzW
         VRzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RmpGWLSFSFSGzHOhv4Fdj7R87ZcL3uRgxrSabqaPqQs=;
        b=CJRRa8CSOHQW/FNhpZ/0/lBBUULyi7GGJwvuVB8PtboYI0/V7Rbdg6ik+7HIoIXdRk
         Otb9qRA5I8NFmzqY7Rqf8dJ/2WrXnr2rHWg7I0Ez3GAwyz0c7ZoSkeeN0XY+nC+SQk7s
         nDw238nOMFGieC0I5gQ0A5BYDJy7hScnZ1NMOHwrkQzyGdNS9hSUTsUMx2OhMR0ld/3U
         hLI851HkpDb/ovEcED6GaHxTTSwvo6o5WFyPx7jT32kmtAVcnkDm3O/mNEB0Z+pv/LrG
         /G/ZsDNEjGnrfXQZOFtsOzQtoxNEXEV8fpoUBXxVF894zx82vSqT2FCzBzCr8g+b3Ejh
         O4BA==
X-Gm-Message-State: APjAAAUQFWiCopjCi9D4VM8ApAF9JfEUArqpT4ppxaXL/9VBhB4M+D7t
        rTwq/jJ080Ba6MYNBuXHUcI9A6n0K6f+ljg8gP3Jk1tL
X-Google-Smtp-Source: APXvYqxJq2zJS7+WK7YHhDbqs5emm3/baAPG20E0urKs/eZJkQ9cd4irvUBaZToqyiJTYn64iE6rFdQjCXm3ooAPgGU=
X-Received: by 2002:a05:651c:104:: with SMTP id a4mr1143364ljb.104.1575342336256;
 Mon, 02 Dec 2019 19:05:36 -0800 (PST)
MIME-Version: 1.0
From:   Wangpan <aspirer2004@gmail.com>
Date:   Tue, 3 Dec 2019 11:05:25 +0800
Message-ID: <CAA9M3Mv5OxMK45iBf3Za_1AjugQbPQcM-FTUc2ybX0oR-2JmRg@mail.gmail.com>
Subject: pg becomes creating+peering state after reweight
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,

I am backporting the async recovery feature to Hammer :(   --- this is
a sad story, but we can't upgrade to Luminous or other new version in
our product envs.
the teuthology tests catch an osd crash error after backport
https://github.com/ceph/ceph/pull/19811
But I have reproduced it with master branch code, the detail are
described as below:

code version: master branch with latest commit
656c8e8049c2c1acd363143c842c2edf1fe09b64

config of vstart:
[client.vstart.sh]
num mon = 1
num osd = 5
num mds = 0
num mgr = 1
num rgw = 0

config of osd/mon/mgr:
[osd]
osd_async_recovery_min_cost = 0  # only add this one, others are
default with vstart

vstart command:
MON=1 OSD=5 MDS=0 MGR=1 RGW=0 ../src/vstart.sh --debug --new -X
--localhost --bluestore --without-dashboard

pool info:
pool 1 'rbd' replicated size 3 min_size 1 crush_rule 0 object_hash
rjenkins pg_num 256 pgp_num 256 autoscale_mode off last_change 31
flags hashpspool,selfmanaged_snaps stripe_width 0 application rbd

osd log:
2019-12-02T09:32:28.779+0000 7f8ff8c82700  5 osd.2 pg_epoch: 783
pg[1.c2( v 657'1488 (0'0,657'1488] local-lis/les=0/0 n=13 ec=25/25
lis/c=0/449 les/c/f=0/450/0 sis=783) [2,1,0] r=0 lpr=783
pi=[449,783)/1 crt=657'1488 mlcod 0'0 unknown mbc={}] enter
Started/Primary
2019-12-02T09:32:28.779+0000 7f8ff8c82700  5 osd.2 pg_epoch: 783
pg[1.c2( v 657'1488 (0'0,657'1488] local-lis/les=0/0 n=13 ec=25/25
lis/c=0/449 les/c/f=0/450/0 sis=783) [2,1,0] r=0 lpr=783
pi=[449,783)/1 crt=657'1488 mlcod 0'0 creating mbc={}] enter
Started/Primary/Peering         ### pg state is creating
2019-12-02T09:32:28.779+0000 7f8ff8c82700  5 osd.2 pg_epoch: 783
pg[1.c2( v 657'1488 (0'0,657'1488] local-lis/les=0/0 n=13 ec=25/25
lis/c=0/449 les/c/f=0/450/0 sis=783) [2,1,0] r=0 lpr=783
pi=[449,783)/1 crt=657'1488 mlcod 0'0 creating+peering mbc={}] enter
Started/Primary/Peering/GetInfo             ### pg state is
creating+peering


Reproduce steps:
1. create a pool, wait for active+clean
2. writes to rbd image with fio or other tool during steps below
3. ceph osd reweight 2 0.1
4. wait several minutes, make sure pg are moved to other osd(grep
"on_removal" osd.2.log)
5. ceph osd reweight 2 1
6. wait several minutes, make sure pg are moved back to original
osd.2(grep "_make_pg" osd.2.log)
7. find a up_primary pg(such as 1.c2 in my log) on osd.2 which was
moved out/back during steps 3~6, and it should enter in async
recovering after step 6
8. wait for pg becomes active+clean, then you can find it had become
to creating+peering state.


the root reason may be:
1. after step 6, osd.0 will be async recovery target in pg 1.c2, and
pg will be created after reweight to 1
2. after pg->init the local_les=0/history.les=450
2019-12-02T09:21:47.991+0000 7f8ff8c82700 10 osd.2 543 _make_pg 1.c2
2019-12-02T09:21:47.991+0000 7f8ff8c82700 10 osd.2 pg_epoch: 543
pg[1.c2( DNE empty local-lis/les=0/0 n=0 ec=0/0 lis/c=0/0
les/c/f=0/0/0 sis=0) [] r=-1 lpr=0 crt=0'0 unknown mbc={}] init role 0
up [2,1,0] acting [2,1,0] history ec=25/25 lis/c=449/449
les/c/f=450/450/0 sis=543 pruub=14.367934206s past_intervals
([449,542] all_participants=0,1,3 intervals=([449,542] acting 0,1,3))
2019-12-02T09:21:47.991+0000 7f8ff8c82700 20 osd.2 pg_epoch: 543
pg[1.c2( empty local-lis/les=0/0 n=0 ec=25/25 lis/c=449/449
les/c/f=450/450/0 sis=543 pruub=14.367934206s) [2,1,0] r=0 lpr=0
pi=[449,543)/1 crt=0'0 mlcod 0'0 unknown mbc={}] on_new_interval
2019-12-02T09:21:48.063+0000 7f8ff8c82700 20 osd.2 pg_epoch: 543
pg[1.c2( empty local-lis/les=0/0 n=0 ec=25/25 lis/c=449/449
les/c/f=450/450/0 sis=543) [2,1,0] r=0 lpr=543 pi=[449,543)/1 crt=0'0
mlcod 0'0 peering mbc={}] choose_async_recovery_replicated result
want=[0,1] async_recovery=2
2019-12-02T09:21:48.983+0000 7f8ff8c82700 20 osd.2 pg_epoch: 544
pg[1.c2( empty local-lis/les=0/0 n=0 ec=25/25 lis/c=449/449
les/c/f=450/450/0 sis=543) [2,1,0] r=0 lpr=544 pi=[449,543)/1 crt=0'0
mlcod 0'0 unknown mbc={}] new interval newup [2,1,0] newacting [0,1]
 ## osd.2 is async recovery target in pg 1.c2
acting_primary osd.0 log:
2019-12-02T09:21:49.195+0000 7f2f01060700 20 osd.0 pg_epoch: 544
pg[1.c2( v 542'940 (0'0,542'940] local-lis/les=449/450 n=13 ec=25/25
lis/c=449/449 les/c/f=450/450/0 sis=544) [2,1,0]/[0,1] r=0 lpr=544
pi=[449,544)/1 crt=542'940 lcod 542'939 mlcod 0'0 remapped+peering
mbc={}] choose_async_recovery_replicated result want=[0,1]
async_recovery=2
3. when repop is coming to osd.2 of pg 1.c2, the append_log func will
find local_les(=0) != history.les(=450), and it will use local_les as
new history.les, then history.les become 0

void PeeringState::append_log(
  const vector<pg_log_entry_t>& logv,
  eversion_t trim_to,
  eversion_t roll_forward_to,
  ObjectStore::Transaction &t,
  bool transaction_applied,
  bool async)
{
  /* The primary has sent an info updating the history, but it may not
   * have arrived yet.  We want to make sure that we cannot remember this
   * write without remembering that it happened in an interval which went
   * active in epoch history.last_epoch_started.
   */
  if (info.last_epoch_started != info.history.last_epoch_started) {
    info.history.last_epoch_started = info.last_epoch_started;
  }
  ...
}

4. when the async recovery of osd.2 in pg 1.c2 is over, it will change
to acting_primary, pg state will be set to PG_STATE_CREATING

PeeringState::Primary::Primary(my_context ctx)
  : my_base(ctx),
    NamedState(context< PeeringMachine >().state_history, "Started/Primary")
{
  context< PeeringMachine >().log_enter(state_name);
  DECLARE_LOCALS;
  ceph_assert(ps->want_acting.empty());

  // set CREATING bit until we have peered for the first time.
  if (ps->info.history.last_epoch_started == 0) {
    ps->state_set(PG_STATE_CREATING);
  ...
}


So my question is that, this PG_STATE_CREATING state after async
recovery is expected or not?
if it is, I guess this creating state may result in osd crash, if
acting_primary is changed during creating+peering state, the process
may be:
1. osd.2 report pg stats to mon
2. mon will add this pg to creating_pgs/creating_pgs_by_osd_epoch
void PGMap::stat_pg_add(const pg_t &pgid, const pg_stat_t &s,
                        bool sameosds)
{
  auto pool = pgid.pool();
  pg_sum.add(s);

  num_pg++;
  num_pg_by_state[s.state]++;
  num_pg_by_pool_state[pgid.pool()][s.state]++;
  num_pg_by_pool[pool]++;

  if ((s.state & PG_STATE_CREATING) &&
      s.parent_split_bits == 0) {
    creating_pgs.insert(pgid);
    if (s.acting_primary >= 0) {
      creating_pgs_by_osd_epoch[s.acting_primary][s.mapping_epoch].insert(pgid);
    }
  }
  ...
}
3. when the acting_primary change to a new one, the new acting_primary
will receive a MOSDPGCreate/MOSDPGCreate2 msg with a very old pg
created epoch(the real created epoch is 5)
4. the new acting_primary will get_osdmap by pg created epoch, this
map is trimmed long time ago, then osd will crash at:
void OSD::build_initial_pg_history(
  spg_t pgid,
  epoch_t created,
  utime_t created_stamp,
  pg_history_t *h,
  PastIntervals *pi)
{
  dout(10) << __func__ << " " << pgid << " created " << created << dendl;
  *h = pg_history_t(created, created_stamp);

  OSDMapRef lastmap = service.get_map(created);
  ...
}
  OSDMapRef get_map(epoch_t e) {
    OSDMapRef ret(try_get_map(e));
    ceph_assert(ret);                 // crash here because map is trimmed
    return ret;
  }

I got a related issue here: https://tracker.ceph.com/issues/14592 osd
crashes when handling a stale pg-create message (hammer) ,
but I'm not sure they are same reason or not.

Thanks for your attention, welcome to ask me for more detail.
