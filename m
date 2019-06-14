Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D16EF4587E
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 11:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfFNJW7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 05:22:59 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:38606 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfFNJW7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Jun 2019 05:22:59 -0400
Received: by mail-ed1-f53.google.com with SMTP id r12so351956edo.5
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 02:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanderster.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sy1fEEajCnRmgb0+JQZhCAP+8Q4IC4DioOC+zuKBEhY=;
        b=Jd41QQMRpS5cnP3+DEvTj9eBSnxWRiJ3/MET5w/z5gvJtUWznqI0UkgFgijZYv1ZCj
         +44113mdysetBBvRQ7lTof3IRLWqLfHXJXK39ANoxv6NKXOYwmqKD5ESYltcTioPyjXq
         ws+DnMX08GVgstbefr98SkK0SvWJo08Xww4Ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sy1fEEajCnRmgb0+JQZhCAP+8Q4IC4DioOC+zuKBEhY=;
        b=a5uqwrRn6uhdKahDHDbqsPsqUB4kV8iG/5XQzR3PrHKSKElwKrWQjJvV6hTLiMk9M8
         FXWyOGeneGGqWthY69RUqSZQcDEynItmmIKP8K3Jlfgxn3wiR66+PNUdaeUt4/pho0e1
         NAVyKrwqbAps5xNXq3eult3QrtrzZZnDzYiVSAytRJ4rvAgfoGoA6F8NyPwQ+jvMR/g/
         17gmzoPYeWjhAjOMnG72GY0nqLvbZVNG8dQ+/DpChqyIhpuoILb7Xu8zngo8fDyto9Om
         UzJE5q3lP59CtPTbEuRQH9+NNpgYjMCtMjhRlZjNCX7irZqhc2FkdH3NXv9XytF0SWvy
         Pgqg==
X-Gm-Message-State: APjAAAVYEomslpQmRCLhZ3lTUSi2cNopNRCxsVtSzQYGz7O0O62mHkiz
        nnpOBIbtgAoetyw5DI4dXdn76a4gLPE=
X-Google-Smtp-Source: APXvYqyCq5LiOjptNqCXPWdds0DrKAOzGBw53w5pv85RP/u8CTTwZiVxjZ+TVmRJVtuMJXFlPbi18Q==
X-Received: by 2002:a50:e619:: with SMTP id y25mr16621712edm.247.1560504176530;
        Fri, 14 Jun 2019 02:22:56 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id n7sm468381ejl.58.2019.06.14.02.22.54
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:22:55 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id v14so1738535wrr.4
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 02:22:54 -0700 (PDT)
X-Received: by 2002:adf:e705:: with SMTP id c5mr33873729wrm.270.1560504174303;
 Fri, 14 Jun 2019 02:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <304057881.20190614111947@tlen.pl>
In-Reply-To: <304057881.20190614111947@tlen.pl>
From:   Dan van der Ster <dan@vanderster.com>
Date:   Fri, 14 Jun 2019 11:22:18 +0200
X-Gmail-Original-Message-ID: <CABZ+qq=Ob4SuvFSbpN-8+NP66_rQJO2_HaNmThVwF6s8vOw+hQ@mail.gmail.com>
Message-ID: <CABZ+qq=Ob4SuvFSbpN-8+NP66_rQJO2_HaNmThVwF6s8vOw+hQ@mail.gmail.com>
Subject: Re: problem with degraded PG
To:     =?UTF-8?Q?=C5=81ukasz_Chrustek?= <skidoo@tlen.pl>
Cc:     ceph-users <ceph-users@lists.ceph.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,
This looks like a tunables issue.
What is the output of `ceph osd crush show-tunables `

-- Dan

On Fri, Jun 14, 2019 at 11:19 AM Luk <skidoo@tlen.pl> wrote:
>
> Hello,
>
> Maybe  somone  was  fighting  with this kind of stuck in ceph already.
> This  is  production  cluster,  can't/don't  want to make wrong steps,
> please advice, what to do.
>
> After  changing  of  one failed disk (it was osd-7) on our cluster ceph
> didn't recover to HEALTH_OK, it stopped in state:
>
> [root@ceph-mon-01 ~]# ceph -s
>   cluster:
>     id:     b6f23cff-7279-f4b0-ff91-21fadac95bb5
>     health: HEALTH_WARN
>             noout,noscrub,nodeep-scrub flag(s) set
>             Degraded data redundancy: 24761/45994899 objects degraded (0.=
054%), 8 pgs degraded, 8 pgs undersized
>
>   services:
>     mon:        3 daemons, quorum ceph-mon-01,ceph-mon-02,ceph-mon-03
>     mgr:        ceph-mon-03(active), standbys: ceph-mon-02, ceph-mon-01
>     osd:        144 osds: 144 up, 144 in
>                 flags noout,noscrub,nodeep-scrub
>     rbd-mirror: 3 daemons active
>     rgw:        6 daemons active
>
>   data:
>     pools:   18 pools, 2176 pgs
>     objects: 15.33M objects, 49.3TiB
>     usage:   151TiB used, 252TiB / 403TiB avail
>     pgs:     24761/45994899 objects degraded (0.054%)
>              2168 active+clean
>              8    active+undersized+degraded
>
>   io:
>     client:   435MiB/s rd, 415MiB/s wr, 7.94kop/s rd, 2.96kop/s wr
>
> Restart of OSD didn't helped, changing choose_total_tries from 50 to 100 =
didn't help.
>
> I checked one of degraded PG, 10.3c4
>
> [root@ceph-mon-01 ~]# ceph pg dump 2>&1 | grep -w 10.3c4
> 10.3c4     3593                  0     3593         0       0 14769891858=
 10076    10076    active+undersized+degraded 2019-06-13 08:19:39.802219  3=
7380'71900564 37380:119411139       [9,109]          9       [9,109]       =
       9  33550'69130424 2019-06-08 02:28:40.508790  33550'69130424 2019-06=
-08 02:28:40.508790            18
>
>
> [root@ceph-mon-01 ~]# ceph pg 10.3c4 query | jq '.["peer_info"][] | {peer=
: .peer, last_update:.last_update}'
> {
>   "peer": "0",
>   "last_update": "36847'71412720"
> }
> {
>   "peer": "109",
>   "last_update": "37380'71900570"
> }
> {
>   "peer": "117",
>   "last_update": "0'0"
> }
>
>
> [root@ceph-mon-01 ~]#
> I have checked space taken for this PG on storage nodes:
> here is how to check where is particular OSD (on which physical storage n=
ode):
> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 9 "
> |  9  |   stor-a02  | 2063G | 5386G |   52   |  1347k  |   53   |   292k =
 | exists,up |
> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 109 "
> | 109 |   stor-a01  | 1285G | 4301G |    5   |  31.0k  |    6   |  59.2k =
 | exists,up |
> [root@ceph-mon-01 ~]# watch ceph -s
> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 117 "
> | 117 |   stor-b02  | 1334G | 4252G |   54   |  1216k  |   13   |  27.4k =
 | exists,up |
> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 0 "
> |  0  |   stor-a01  | 2156G | 5293G |   58   |   387k  |   29   |  30.7k =
 | exists,up |
> [root@ceph-mon-01 ~]#
> and checking sizes on servers:
> stor-a01 (this PG shouldn't be on the same host):
> [root@stor-a01 /var/lib/ceph/osd/ceph-0/current]# du -sh 10.3c4_*
> 2.4G    10.3c4_head
> 0       10.3c4_TEMP
> [root@stor-a01 /var/lib/ceph/osd/ceph-109/current]# du -sh 10.3c4_*
> 14G     10.3c4_head
> 0       10.3c4_TEMP
> [root@stor-a01 /var/lib/ceph/osd/ceph-109/current]#
> stor-a02:
> [root@stor-a02 /var/lib/ceph/osd/ceph-9/current]# du -sh 10.3c4_*
> 14G     10.3c4_head
> 0       10.3c4_TEMP
> [root@stor-a02 /var/lib/ceph/osd/ceph-9/current]#
> stor-b02:
> [root@stor-b02 /var/lib/ceph/osd/ceph-117/current]# du -sh 10.3c4_*
> zsh: no matches found: 10.3c4_*
>
> information about ceph:
> [root@ceph-mon-01 ~]# ceph versions
> {
>     "mon": {
>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) l=
uminous (stable)": 3
>     },
>     "mgr": {
>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) l=
uminous (stable)": 3
>     },
>     "osd": {
>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) l=
uminous (stable)": 144
>     },
>     "mds": {},
>     "rbd-mirror": {
>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) l=
uminous (stable)": 3
>     },
>     "rgw": {
>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) l=
uminous (stable)": 6
>     },
>     "overall": {
>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217) l=
uminous (stable)": 159
>     }
> }
>
> crushmap: https://pastebin.com/cpC2WmyS
> ceph osd tree: https://pastebin.com/XvZ2cNZZ
>
> I'm  cross-posting this do devel because maybe there is some known bug
> in  this  particular  version  of  ceph,  and  You  could  point  some
> directions to fix this problem.
>
> --
> Regards
> Lukasz
>
