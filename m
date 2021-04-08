Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B72358B46
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Apr 2021 19:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhDHRZB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Apr 2021 13:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbhDHRZB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Apr 2021 13:25:01 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70DAC061760
        for <ceph-devel@vger.kernel.org>; Thu,  8 Apr 2021 10:24:48 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id y124-20020a1c32820000b029010c93864955so3335562wmy.5
        for <ceph-devel@vger.kernel.org>; Thu, 08 Apr 2021 10:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Ing7EKktJEZfhMJCiJAQwEJ0LCq9rAbiIxGDwrWMrgQ=;
        b=mpfPNkBoVK4rWKkFTtiXM0NRlySkF4K0fLZnw62pe+74D7DcQz264WRtQKCe19sPgM
         EH9cr0C4XSm9T8MEVySyIR5S8rd1kGk7/ZCTx7X+TyR1666+VChf1Te3yXoRIc49JAvQ
         CkBvenqNbBS2Uc/cSQHxiNWPH2dPkRQPu4T770reu813FgUEbtj5CYo2wR5/DrdwMSIC
         +5VR0mvSEF4oyK6JVq7HILvuWoSuScXYe9zdZSitaNMj+pAG++1bXaDwSmSJx/7ZOhR+
         hggqL1qiaRHxSObFfCmJkSmfdLQmZtN8FB1NwF/ZvzDtdbnkEAnv97c9yo8wR/fOpD7q
         nkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Ing7EKktJEZfhMJCiJAQwEJ0LCq9rAbiIxGDwrWMrgQ=;
        b=WJ4WHqI9mzb6MY89UhEhiCQZxDbpxK1aEC+3Zq1AvooRr2h9/Vw1QGW5j4GuCo8U+a
         i/NBJehOwMtgyHOdJU2/NwfC1KzPd9DwTBg+fI4aMDRKtlwtougSV+ysdz4ZnP+J23Jz
         B4kDGd6xBE6ofsjyEnrzBWJZFINpQE3kLV1wXgJK86S2QIdnH9dpOX1d4Ml44XqzTFFD
         9+uI4WAxtxzSgjig/zojwOdx87JgdTmqT/vyvo6WUGyiO21H6YtdbdOn8a4FNXuu4tE6
         UxN3hnLujfLC1NAYf+IFC52NwQyqiIIIA7xdu8qZteJwp2d5tal/bsWmKfN61dPYsZNw
         X7UQ==
X-Gm-Message-State: AOAM531FFycfCvdhaHaRqLCS5hTcnCAHZXzJfc1vSyyws73E+reify4d
        R0MYBndTgRbwPO/2sdnjvK1/Fnardaspvg+z7LVnYvGFoczqfg==
X-Google-Smtp-Source: ABdhPJyGADVxnHR+DuYA4f/uFErDEwFiLZWJMiPevi9sKOOHanBMFVB5TZLNUmVC6jL1dmcKSmtnBZqcbXUQZhpAQQc=
X-Received: by 2002:a05:600c:364c:: with SMTP id y12mr9940415wmq.96.1617902687219;
 Thu, 08 Apr 2021 10:24:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAANLjFpjRLtV+GR4WV15iXXCvkig6tJAr_G=_bZpZ=jKnYfvTQ@mail.gmail.com>
In-Reply-To: <CAANLjFpjRLtV+GR4WV15iXXCvkig6tJAr_G=_bZpZ=jKnYfvTQ@mail.gmail.com>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Thu, 8 Apr 2021 11:24:36 -0600
Message-ID: <CAANLjFrSgYw3qDu46gJPOUQXOojz9yuPj3EOYwvLtQnTmgGe_w@mail.gmail.com>
Subject: Re: Nautilus 14.2.19 mon 100% CPU
To:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 8, 2021 at 10:22 AM Robert LeBlanc <robert@leblancnet.us> wrote=
:
>
> I upgraded our Luminous cluster to Nautilus a couple of weeks ago and con=
verted the last batch of FileStore OSDs to BlueStore about 36 hours ago. Ye=
sterday our monitor cluster went nuts and started constantly calling electi=
ons because monitor nodes were at 100% and wouldn't respond to heartbeats. =
I reduced the monitor cluster to one to prevent the constant elections and =
that let the system limp along until the backfills finished. There are larg=
e amounts of time where ceph commands hang with the CPU is at 100%, when th=
e CPU drops I see a lot of work getting done in the monitor logs which stop=
s as soon as the CPU is at 100% again.
>
> I did a `perf top` on the node to see what's taking all the time and it a=
ppears to be in the rocksdb code path. I've set `mon_compact_on_start =3D t=
rue` in the ceph.conf but that does not appear to help. The `/var/lib/ceph/=
mon/` directory is 311MB which is down from 3.0 GB while the backfills were=
 going on. I've tried adding a second monitor, but it goes back to the cons=
tant elections. I tried restarting all the services without luck. I also pu=
lled the monitor from the network work and tried restarting the mon service=
 isolated (this helped a couple of weeks ago when `ceph -s` would cause 100=
% CPU and lock up the service much worse than this) and didn't see the high=
 CPU load. So I'm guessing it's triggered from some external source.
>
> I'm happy to provide more info, just let me know what would be helpful.

Sent this to the dev list, but forgot it needed to be plain text. Here
is text output of the `perf top` taken a bit later, so not exactly the
same as the screenshot earlier.

Samples: 20M of event 'cycles', 4000 Hz, Event count (approx.):
61966526527 lost: 0/0 drop: 0/0
Overhead  Shared Object                             Symbol
 11.52%  ceph-mon                                  [.]
rocksdb::MemTable::KeyComparator::operator()
  6.80%  ceph-mon                                  [.]
rocksdb::MemTable::KeyComparator::operator()
  4.75%  ceph-mon                                  [.]
rocksdb::InlineSkipList<rocksdb::MemTableRep::KeyComparator
const&>::FindGreaterOrEqual
  2.89%  libc-2.27.so                              [.] vfprintf
  2.54%  libtcmalloc.so.4.3.0                      [.] tc_deletearray_nothr=
ow
  2.31%  ceph-mon                                  [.] TLS init
function for rocksdb::perf_context
  2.14%  ceph-mon                                  [.] rocksdb::DBImpl::Get=
Impl
  1.53%  libc-2.27.so                              [.] 0x000000000018acf8
  1.44%  libc-2.27.so                              [.] _IO_default_xsputn
  1.34%  ceph-mon                                  [.] memcmp@plt
  1.32%  libtcmalloc.so.4.3.0                      [.] tc_malloc
  1.28%  ceph-mon                                  [.] rocksdb::Version::Ge=
t
  1.27%  libc-2.27.so                              [.] 0x000000000018abf4
  1.17%  ceph-mon                                  [.] RocksDBStore::get
  1.08%  ceph-mon                                  [.] 0x0000000000639a33
  1.04%  ceph-mon                                  [.] 0x0000000000639a0e
  0.89%  ceph-mon                                  [.] 0x0000000000639a46
  0.86%  ceph-mon                                  [.] rocksdb::TableCache:=
:Get
  0.72%  libc-2.27.so                              [.] 0x000000000018abfe
  0.68%  libceph-common.so.0                       [.] ceph_str_hash_rjenki=
ns
  0.66%  ceph-mon                                  [.] rocksdb::Hash
  0.63%  ceph-mon                                  [.] rocksdb::MemTable::G=
et
  0.62%  ceph-mon                                  [.] 0x00000000006399ff
  0.57%  libc-2.27.so                              [.] 0x000000000018abf0
  0.57%  ceph-mon                                  [.]
rocksdb::GetContext::GetContext
  0.57%  ceph-mon                                  [.]
rocksdb::BlockBasedTable::Get
  0.57%  ceph-mon                                  [.]
rocksdb::BlockBasedTable::GetFilter
  0.55%  [vdso]                                    [.] __vdso_clock_gettime
  0.54%  ceph-mon                                  [.] 0x00000000005afa17
  0.53%  ceph-mgr                                  [.]
std::_Rb_tree<pg_t, pg_t, std::_Identity<pg_t>, std::less<pg_t>,
std::allocator<pg_t> >::equal_range
  0.51%  libceph-common.so.0                       [.] PerfCounters::tinc
  0.50%  ceph-mon                                  [.]
OSDMonitor::make_snap_epoch_key[abi:cxx11]
