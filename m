Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC874734C
	for <lists+ceph-devel@lfdr.de>; Sun, 16 Jun 2019 07:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbfFPFC7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Jun 2019 01:02:59 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:35325 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfFPFC7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Jun 2019 01:02:59 -0400
Received: by mail-qt1-f178.google.com with SMTP id d23so7252995qto.2
        for <ceph-devel@vger.kernel.org>; Sat, 15 Jun 2019 22:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5Kj2Shqn2+oyaxR6+olBL/nB4cBQXVMHcPKURy2NeNw=;
        b=L3cMf+iyQIiOMMUqk+bR+1wJKNl+dV4OqtljpAF1GkMpc7DQkoF8SZLcTab+lSvtuX
         vD4//YUPNB9co4LBnFdrI3X8mKsTZGs0TY5HX9/7bor0Xc4gZRS33ff3rrvQHh6FNMxn
         aszIX5SYREPi+XKXTnA7L6Oh+nbAVrJoSLoeKsjJbfxXXPdZRR97vDmriJbVnN95RRZG
         LzqXVvOWCOSl7mjyMn9L16uxXF2FuvqOHx/3tLvhp3BOgLtBGrNyzrQCS5ZXsHzpztUh
         PpQdI2kUMCarne9owQigPGhfVNgSuU2R5djSjfCEAaOMFQt9+cAqi60ykd1rsAm4/tul
         ZfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5Kj2Shqn2+oyaxR6+olBL/nB4cBQXVMHcPKURy2NeNw=;
        b=Ci1bBY0uxBHwFpR6vK+7tnrjCk+txkyDrWUQy6jJWG+J8RqguAbkId2q/tj8VC+ApS
         UreBo3cByquN5ZOHpAwC8SFQ18SOpEtVSp6B+JTzGfLcW6nqPi/LxoIxO7gxzHcd6cyI
         djYSAeo0LUl+MId8ge6NB41cjdtF8FfOGxPz8z9xmJgvap4bYLljp9quz9+SeT0VGBz1
         CsxLsnmsoSUXOg5tSo8fCe15221ZqGMVuWBdruaix92yTqKFhxj0YfeB40lsZHTHFODP
         HgoaiyMW3fNUzNeiTALmU8zY1ddlI0pu18leNlupa8CDZn3vkOgPOrj3eAuYaQShM2rU
         MGrQ==
X-Gm-Message-State: APjAAAVIzm2/7mq9Dk0JGBOqcogXLUY2qRtYDTvc3krxgPgikOwYbQO9
        jq6nK+E9ES2CsQ4Fs/INQiyohM5GrQCly+NAI9k=
X-Google-Smtp-Source: APXvYqz2HMi2fbyj+IQQPp7TyYmdD0rflM80zqDm4bK4EJx6aHr7r9CkPdp9aafUEp2La7nX7DtA56tpVQJm9TmwP/0=
X-Received: by 2002:ac8:25e7:: with SMTP id f36mr76700586qtf.139.1560661378284;
 Sat, 15 Jun 2019 22:02:58 -0700 (PDT)
MIME-Version: 1.0
References: <304057881.20190614111947@tlen.pl> <CABZ+qq=Ob4SuvFSbpN-8+NP66_rQJO2_HaNmThVwF6s8vOw+hQ@mail.gmail.com>
 <1171202508.20190614112950@tlen.pl> <CABZ+qqmN0zG57Oqtv3wMLHrfXEwCPfGQARewq=hkjOxmZ0=G6g@mail.gmail.com>
 <661486857.20190614115232@tlen.pl> <1585044179.20190614140202@tlen.pl>
In-Reply-To: <1585044179.20190614140202@tlen.pl>
From:   huang jun <hjwsm1989@gmail.com>
Date:   Sun, 16 Jun 2019 13:02:46 +0800
Message-ID: <CABAwU-Z4nD6Vf3_6OCvvBR-hobVOZTekM=b2X5PRwAXvj8mEGA@mail.gmail.com>
Subject: Re: [ceph-users] problem with degraded PG
To:     =?UTF-8?Q?=C5=81ukasz_Chrustek?= <skidoo@tlen.pl>
Cc:     Dan van der Ster <dan@vanderster.com>,
        ceph-users <ceph-users@lists.ceph.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

can you show us the output of 'ceph osd dump' and 'ceph health detail'?

Luk <skidoo@tlen.pl> =E4=BA=8E2019=E5=B9=B46=E6=9C=8814=E6=97=A5=E5=91=A8=
=E4=BA=94 =E4=B8=8B=E5=8D=888:02=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello,
>
> All kudos are going to friends from Wroclaw, PL :)
>
> It was as simple as typo...
>
> There  was osd added two times to crushmap due to (this commands where
> run  over  week  ago  -  didn't  have problem then, it showed up after
> replacing another osd - osd-7):
>
> ceph osd crush add osd.112 0.00 root=3Dhdd
> ceph osd crush move osd.112 0.00 root=3Dhdd rack=3Drack-a host=3Dstor-a02
> ceph osd crush add osd.112 0.00 host=3Dstor-a02
>
> and the ceph osd tree was like this:
> [root@ceph-mon-01 ~]# ceph osd tree
> ID   CLASS WEIGHT    TYPE NAME                 STATUS REWEIGHT PRI-AFF
> -100       200.27496 root hdd
> -101        67.64999     rack rack-a
>   -2        33.82500         host stor-a01
>    0   hdd   7.27499             osd.0             up  1.00000 1.00000
>    6   hdd   7.27499             osd.6             up  1.00000 1.00000
>   12   hdd   7.27499             osd.12            up  1.00000 1.00000
>  108   hdd   4.00000             osd.108           up  1.00000 1.00000
>  109   hdd   4.00000             osd.109           up  1.00000 1.00000
>  110   hdd   4.00000             osd.110           up  1.00000 1.00000
>   -7        33.82500         host stor-a02
>    5   hdd   7.27499             osd.5             up  1.00000 1.00000
>    9   hdd   7.27499             osd.9             up  1.00000 1.00000
>   15   hdd   7.27499             osd.15            up  1.00000 1.00000
>  111   hdd   4.00000             osd.111           up  1.00000 1.00000
>  112   hdd   4.00000             osd.112           up  1.00000 1.00000
>  113   hdd   4.00000             osd.113           up  1.00000 1.00000
> -102        60.97498     rack rack-b
>   -3        27.14998         host stor-b01
>    1   hdd   7.27499             osd.1             up  1.00000 1.00000
>    7   hdd   0.59999             osd.7             up  1.00000 1.00000
>   13   hdd   7.27499             osd.13            up  1.00000 1.00000
>  114   hdd   4.00000             osd.114           up  1.00000 1.00000
>  115   hdd   4.00000             osd.115           up  1.00000 1.00000
>  116   hdd   4.00000             osd.116           up  1.00000 1.00000
>   -4        33.82500         host stor-b02
>    2   hdd   7.27499             osd.2             up  1.00000 1.00000
>   10   hdd   7.27499             osd.10            up  1.00000 1.00000
>   16   hdd   7.27499             osd.16            up  1.00000 1.00000
>  117   hdd   4.00000             osd.117           up  1.00000 1.00000
>  118   hdd   4.00000             osd.118           up  1.00000 1.00000
>  119   hdd   4.00000             osd.119           up  1.00000 1.00000
> -103        67.64999     rack rack-c
>   -6        33.82500         host stor-c01
>    4   hdd   7.27499             osd.4             up  1.00000 1.00000
>    8   hdd   7.27499             osd.8             up  1.00000 1.00000
>   14   hdd   7.27499             osd.14            up  1.00000 1.00000
>  120   hdd   4.00000             osd.120           up  1.00000 1.00000
>  121   hdd   4.00000             osd.121           up  1.00000 1.00000
>  122   hdd   4.00000             osd.122           up  1.00000 1.00000
>   -5        33.82500         host stor-c02
>    3   hdd   7.27499             osd.3             up  1.00000 1.00000
>   11   hdd   7.27499             osd.11            up  1.00000 1.00000
>   17   hdd   7.27499             osd.17            up  1.00000 1.00000
>  123   hdd   4.00000             osd.123           up  1.00000 1.00000
>  124   hdd   4.00000             osd.124           up  1.00000 1.00000
>  125   hdd   4.00000             osd.125           up  1.00000 1.00000
>  112   hdd   4.00000     osd.112                   up  1.00000 1.00000
>
>  [cut]
>
>  after  editing  crushmap  and removing osd.112 from root ceph started
>  recover and is healthy now :)
>
>  Regards
>  Lukasz
>
>
> > Here is ceph osd tree, in first post there is also ceph osd df tree:
>
> > https://pastebin.com/Vs75gpwZ
>
>
>
> >> Ahh I was thinking of chooseleaf_vary_r, which you already have.
> >> So probably not related to tunables. What is your `ceph osd tree` ?
>
> >> By the way, 12.2.9 has an unrelated bug (details
> >> http://tracker.ceph.com/issues/36686)
> >> AFAIU you will just need to update to v12.2.11 or v12.2.12 for that fi=
x.
>
> >> -- Dan
>
> >> On Fri, Jun 14, 2019 at 11:29 AM Luk <skidoo@tlen.pl> wrote:
> >>>
> >>> Hi,
> >>>
> >>> here is the output:
> >>>
> >>> ceph osd crush show-tunables
> >>> {
> >>>     "choose_local_tries": 0,
> >>>     "choose_local_fallback_tries": 0,
> >>>     "choose_total_tries": 100,
> >>>     "chooseleaf_descend_once": 1,
> >>>     "chooseleaf_vary_r": 1,
> >>>     "chooseleaf_stable": 0,
> >>>     "straw_calc_version": 1,
> >>>     "allowed_bucket_algs": 22,
> >>>     "profile": "unknown",
> >>>     "optimal_tunables": 0,
> >>>     "legacy_tunables": 0,
> >>>     "minimum_required_version": "hammer",
> >>>     "require_feature_tunables": 1,
> >>>     "require_feature_tunables2": 1,
> >>>     "has_v2_rules": 0,
> >>>     "require_feature_tunables3": 1,
> >>>     "has_v3_rules": 0,
> >>>     "has_v4_buckets": 1,
> >>>     "require_feature_tunables5": 0,
> >>>     "has_v5_rules": 0
> >>> }
> >>>
> >>> [root@ceph-mon-01 ~]#
> >>>
> >>> --
> >>> Regards
> >>> Lukasz
> >>>
> >>> > Hi,
> >>> > This looks like a tunables issue.
> >>> > What is the output of `ceph osd crush show-tunables `
> >>>
> >>> > -- Dan
> >>>
> >>> > On Fri, Jun 14, 2019 at 11:19 AM Luk <skidoo@tlen.pl> wrote:
> >>> >>
> >>> >> Hello,
> >>> >>
> >>> >> Maybe  somone  was  fighting  with this kind of stuck in ceph alre=
ady.
> >>> >> This  is  production  cluster,  can't/don't  want to make wrong st=
eps,
> >>> >> please advice, what to do.
> >>> >>
> >>> >> After  changing  of  one failed disk (it was osd-7) on our cluster=
 ceph
> >>> >> didn't recover to HEALTH_OK, it stopped in state:
> >>> >>
> >>> >> [root@ceph-mon-01 ~]# ceph -s
> >>> >>   cluster:
> >>> >>     id:     b6f23cff-7279-f4b0-ff91-21fadac95bb5
> >>> >>     health: HEALTH_WARN
> >>> >>             noout,noscrub,nodeep-scrub flag(s) set
> >>> >>             Degraded data redundancy: 24761/45994899 objects degra=
ded (0.054%), 8 pgs degraded, 8 pgs undersized
> >>> >>
> >>> >>   services:
> >>> >>     mon:        3 daemons, quorum ceph-mon-01,ceph-mon-02,ceph-mon=
-03
> >>> >>     mgr:        ceph-mon-03(active), standbys: ceph-mon-02, ceph-m=
on-01
> >>> >>     osd:        144 osds: 144 up, 144 in
> >>> >>                 flags noout,noscrub,nodeep-scrub
> >>> >>     rbd-mirror: 3 daemons active
> >>> >>     rgw:        6 daemons active
> >>> >>
> >>> >>   data:
> >>> >>     pools:   18 pools, 2176 pgs
> >>> >>     objects: 15.33M objects, 49.3TiB
> >>> >>     usage:   151TiB used, 252TiB / 403TiB avail
> >>> >>     pgs:     24761/45994899 objects degraded (0.054%)
> >>> >>              2168 active+clean
> >>> >>              8    active+undersized+degraded
> >>> >>
> >>> >>   io:
> >>> >>     client:   435MiB/s rd, 415MiB/s wr, 7.94kop/s rd, 2.96kop/s wr
> >>> >>
> >>> >> Restart of OSD didn't helped, changing choose_total_tries from 50 =
to 100 didn't help.
> >>> >>
> >>> >> I checked one of degraded PG, 10.3c4
> >>> >>
> >>> >> [root@ceph-mon-01 ~]# ceph pg dump 2>&1 | grep -w 10.3c4
> >>> >> 10.3c4     3593                  0     3593         0       0 1476=
9891858 10076    10076    active+undersized+degraded 2019-06-13 08:19:39.80=
2219  37380'71900564 37380:119411139       [9,109]          9       [9,109]=
              9  33550'69130424 2019-06-08 02:28:40.508790  33550'69130424 =
2019-06-08 02:28:40.508790            18
> >>> >>
> >>> >>
> >>> >> [root@ceph-mon-01 ~]# ceph pg 10.3c4 query | jq '.["peer_info"][] =
| {peer: .peer, last_update:.last_update}'
> >>> >> {
> >>> >>   "peer": "0",
> >>> >>   "last_update": "36847'71412720"
> >>> >> }
> >>> >> {
> >>> >>   "peer": "109",
> >>> >>   "last_update": "37380'71900570"
> >>> >> }
> >>> >> {
> >>> >>   "peer": "117",
> >>> >>   "last_update": "0'0"
> >>> >> }
> >>> >>
> >>> >>
> >>> >> [root@ceph-mon-01 ~]#
> >>> >> I have checked space taken for this PG on storage nodes:
> >>> >> here is how to check where is particular OSD (on which physical st=
orage node):
> >>> >> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 9 "
> >>> >> |  9  |   stor-a02  | 2063G | 5386G |   52   |  1347k  |   53   | =
  292k  | exists,up |
> >>> >> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 109 "
> >>> >> | 109 |   stor-a01  | 1285G | 4301G |    5   |  31.0k  |    6   | =
 59.2k  | exists,up |
> >>> >> [root@ceph-mon-01 ~]# watch ceph -s
> >>> >> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 117 "
> >>> >> | 117 |   stor-b02  | 1334G | 4252G |   54   |  1216k  |   13   | =
 27.4k  | exists,up |
> >>> >> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 0 "
> >>> >> |  0  |   stor-a01  | 2156G | 5293G |   58   |   387k  |   29   | =
 30.7k  | exists,up |
> >>> >> [root@ceph-mon-01 ~]#
> >>> >> and checking sizes on servers:
> >>> >> stor-a01 (this PG shouldn't be on the same host):
> >>> >> [root@stor-a01 /var/lib/ceph/osd/ceph-0/current]# du -sh 10.3c4_*
> >>> >> 2.4G    10.3c4_head
> >>> >> 0       10.3c4_TEMP
> >>> >> [root@stor-a01 /var/lib/ceph/osd/ceph-109/current]# du -sh 10.3c4_=
*
> >>> >> 14G     10.3c4_head
> >>> >> 0       10.3c4_TEMP
> >>> >> [root@stor-a01 /var/lib/ceph/osd/ceph-109/current]#
> >>> >> stor-a02:
> >>> >> [root@stor-a02 /var/lib/ceph/osd/ceph-9/current]# du -sh 10.3c4_*
> >>> >> 14G     10.3c4_head
> >>> >> 0       10.3c4_TEMP
> >>> >> [root@stor-a02 /var/lib/ceph/osd/ceph-9/current]#
> >>> >> stor-b02:
> >>> >> [root@stor-b02 /var/lib/ceph/osd/ceph-117/current]# du -sh 10.3c4_=
*
> >>> >> zsh: no matches found: 10.3c4_*
> >>> >>
> >>> >> information about ceph:
> >>> >> [root@ceph-mon-01 ~]# ceph versions
> >>> >> {
> >>> >>     "mon": {
> >>> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f=
4217) luminous (stable)": 3
> >>> >>     },
> >>> >>     "mgr": {
> >>> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f=
4217) luminous (stable)": 3
> >>> >>     },
> >>> >>     "osd": {
> >>> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f=
4217) luminous (stable)": 144
> >>> >>     },
> >>> >>     "mds": {},
> >>> >>     "rbd-mirror": {
> >>> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f=
4217) luminous (stable)": 3
> >>> >>     },
> >>> >>     "rgw": {
> >>> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f=
4217) luminous (stable)": 6
> >>> >>     },
> >>> >>     "overall": {
> >>> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f=
4217) luminous (stable)": 159
> >>> >>     }
> >>> >> }
> >>> >>
> >>> >> crushmap: https://pastebin.com/cpC2WmyS
> >>> >> ceph osd tree: https://pastebin.com/XvZ2cNZZ
> >>> >>
> >>> >> I'm  cross-posting this do devel because maybe there is some known=
 bug
> >>> >> in  this  particular  version  of  ceph,  and  You  could  point  =
some
> >>> >> directions to fix this problem.
> >>> >>
> >>> >> --
> >>> >> Regards
> >>> >> Lukasz
> >>> >>
> >>>
> >>>
> >>>
> >>> --
> >>> Pozdrowienia,
> >>>  Luk
> >>>
>
>
>
>
>
>
> --
> Pozdrowienia,
>  Luk
>
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
