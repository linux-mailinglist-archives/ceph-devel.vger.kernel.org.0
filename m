Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D01EB458E7
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 11:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfFNJjB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 05:39:01 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:41749 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfFNJjB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Jun 2019 05:39:01 -0400
Received: by mail-ed1-f52.google.com with SMTP id p15so2587066eds.8
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 02:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanderster.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1LlbZV6u0GkN1ZSi6eGRh+SD4DifJb4D8gQ1Yhh34cw=;
        b=jqcScMvXTnywRpXXf6YANHhQMzYGz87IwKe1CfTEK2bbTKvznwumGG9JELeJF4fLf3
         uSThEeYZW5KY8DibRNHIpaufbPprO9V+4j/4TmTdiMQdLCfvMORYbrAKWpW9bAbH02gc
         fIxLILVDKFVBLmv2b6sizZt1Hc0K3x1klVkfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1LlbZV6u0GkN1ZSi6eGRh+SD4DifJb4D8gQ1Yhh34cw=;
        b=k+FmBt7eK6OkvNQrBV/8dvekF9NbDQtIBPWzgLGqIlrNk1Efy5UwDWdRBB5DcoxvpT
         DsKJAspGr89rg0929j8AMriP49Fl6mapr5SYN5mO2Wi5YET1XTEdZjHwdkG5PySbtOqP
         Mzvm6MjICCNosUX7CQ2d82wOQswVRDhFmNzSHsszxSGjMVA6viWdRu6vLAfNMnohAZxx
         MjSSlH+o8UfVstqO8IP+EyV2d7MowQ8e+U+ZOd9+E+bhLzc+2uWKtxwuVrXfrHnc6Mv7
         fvGSrPP1ZtUTL23ISjqGZzA/lxtaIBkMzU353lDdeIGrVp1wipFFNUa1IV3pfVJ/N7wb
         nCHw==
X-Gm-Message-State: APjAAAU1vcyjAhXMIv9XMmsronpmZdM0GLiCscJSqcIfnxW8rV+h2cD4
        rYfyKLFAj5AeX08X57X5WE0YVe0oPQw=
X-Google-Smtp-Source: APXvYqz1bjo/gRq6PPy7VC0j21J4BDBGYiD1PNGhYN8cI08alOpFbXGSYaM+1pJdeLkI6LEAddo74g==
X-Received: by 2002:a50:f5f5:: with SMTP id x50mr14132887edm.89.1560505138105;
        Fri, 14 Jun 2019 02:38:58 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id o7sm478399ejm.67.2019.06.14.02.38.57
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:38:57 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id g135so1610191wme.4
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 02:38:57 -0700 (PDT)
X-Received: by 2002:a7b:cae2:: with SMTP id t2mr5989403wml.157.1560505136881;
 Fri, 14 Jun 2019 02:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <304057881.20190614111947@tlen.pl> <CABZ+qq=Ob4SuvFSbpN-8+NP66_rQJO2_HaNmThVwF6s8vOw+hQ@mail.gmail.com>
 <1171202508.20190614112950@tlen.pl>
In-Reply-To: <1171202508.20190614112950@tlen.pl>
From:   Dan van der Ster <dan@vanderster.com>
Date:   Fri, 14 Jun 2019 11:38:21 +0200
X-Gmail-Original-Message-ID: <CABZ+qqmN0zG57Oqtv3wMLHrfXEwCPfGQARewq=hkjOxmZ0=G6g@mail.gmail.com>
Message-ID: <CABZ+qqmN0zG57Oqtv3wMLHrfXEwCPfGQARewq=hkjOxmZ0=G6g@mail.gmail.com>
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

Ahh I was thinking of chooseleaf_vary_r, which you already have.
So probably not related to tunables. What is your `ceph osd tree` ?

By the way, 12.2.9 has an unrelated bug (details
http://tracker.ceph.com/issues/36686)
AFAIU you will just need to update to v12.2.11 or v12.2.12 for that fix.

-- Dan

On Fri, Jun 14, 2019 at 11:29 AM Luk <skidoo@tlen.pl> wrote:
>
> Hi,
>
> here is the output:
>
> ceph osd crush show-tunables
> {
>     "choose_local_tries": 0,
>     "choose_local_fallback_tries": 0,
>     "choose_total_tries": 100,
>     "chooseleaf_descend_once": 1,
>     "chooseleaf_vary_r": 1,
>     "chooseleaf_stable": 0,
>     "straw_calc_version": 1,
>     "allowed_bucket_algs": 22,
>     "profile": "unknown",
>     "optimal_tunables": 0,
>     "legacy_tunables": 0,
>     "minimum_required_version": "hammer",
>     "require_feature_tunables": 1,
>     "require_feature_tunables2": 1,
>     "has_v2_rules": 0,
>     "require_feature_tunables3": 1,
>     "has_v3_rules": 0,
>     "has_v4_buckets": 1,
>     "require_feature_tunables5": 0,
>     "has_v5_rules": 0
> }
>
> [root@ceph-mon-01 ~]#
>
> --
> Regards
> Lukasz
>
> > Hi,
> > This looks like a tunables issue.
> > What is the output of `ceph osd crush show-tunables `
>
> > -- Dan
>
> > On Fri, Jun 14, 2019 at 11:19 AM Luk <skidoo@tlen.pl> wrote:
> >>
> >> Hello,
> >>
> >> Maybe  somone  was  fighting  with this kind of stuck in ceph already.
> >> This  is  production  cluster,  can't/don't  want to make wrong steps,
> >> please advice, what to do.
> >>
> >> After  changing  of  one failed disk (it was osd-7) on our cluster cep=
h
> >> didn't recover to HEALTH_OK, it stopped in state:
> >>
> >> [root@ceph-mon-01 ~]# ceph -s
> >>   cluster:
> >>     id:     b6f23cff-7279-f4b0-ff91-21fadac95bb5
> >>     health: HEALTH_WARN
> >>             noout,noscrub,nodeep-scrub flag(s) set
> >>             Degraded data redundancy: 24761/45994899 objects degraded =
(0.054%), 8 pgs degraded, 8 pgs undersized
> >>
> >>   services:
> >>     mon:        3 daemons, quorum ceph-mon-01,ceph-mon-02,ceph-mon-03
> >>     mgr:        ceph-mon-03(active), standbys: ceph-mon-02, ceph-mon-0=
1
> >>     osd:        144 osds: 144 up, 144 in
> >>                 flags noout,noscrub,nodeep-scrub
> >>     rbd-mirror: 3 daemons active
> >>     rgw:        6 daemons active
> >>
> >>   data:
> >>     pools:   18 pools, 2176 pgs
> >>     objects: 15.33M objects, 49.3TiB
> >>     usage:   151TiB used, 252TiB / 403TiB avail
> >>     pgs:     24761/45994899 objects degraded (0.054%)
> >>              2168 active+clean
> >>              8    active+undersized+degraded
> >>
> >>   io:
> >>     client:   435MiB/s rd, 415MiB/s wr, 7.94kop/s rd, 2.96kop/s wr
> >>
> >> Restart of OSD didn't helped, changing choose_total_tries from 50 to 1=
00 didn't help.
> >>
> >> I checked one of degraded PG, 10.3c4
> >>
> >> [root@ceph-mon-01 ~]# ceph pg dump 2>&1 | grep -w 10.3c4
> >> 10.3c4     3593                  0     3593         0       0 14769891=
858 10076    10076    active+undersized+degraded 2019-06-13 08:19:39.802219=
  37380'71900564 37380:119411139       [9,109]          9       [9,109]    =
          9  33550'69130424 2019-06-08 02:28:40.508790  33550'69130424 2019=
-06-08 02:28:40.508790            18
> >>
> >>
> >> [root@ceph-mon-01 ~]# ceph pg 10.3c4 query | jq '.["peer_info"][] | {p=
eer: .peer, last_update:.last_update}'
> >> {
> >>   "peer": "0",
> >>   "last_update": "36847'71412720"
> >> }
> >> {
> >>   "peer": "109",
> >>   "last_update": "37380'71900570"
> >> }
> >> {
> >>   "peer": "117",
> >>   "last_update": "0'0"
> >> }
> >>
> >>
> >> [root@ceph-mon-01 ~]#
> >> I have checked space taken for this PG on storage nodes:
> >> here is how to check where is particular OSD (on which physical storag=
e node):
> >> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 9 "
> >> |  9  |   stor-a02  | 2063G | 5386G |   52   |  1347k  |   53   |   29=
2k  | exists,up |
> >> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 109 "
> >> | 109 |   stor-a01  | 1285G | 4301G |    5   |  31.0k  |    6   |  59.=
2k  | exists,up |
> >> [root@ceph-mon-01 ~]# watch ceph -s
> >> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 117 "
> >> | 117 |   stor-b02  | 1334G | 4252G |   54   |  1216k  |   13   |  27.=
4k  | exists,up |
> >> [root@ceph-mon-01 ~]# ceph osd status 2>&1 | grep " 0 "
> >> |  0  |   stor-a01  | 2156G | 5293G |   58   |   387k  |   29   |  30.=
7k  | exists,up |
> >> [root@ceph-mon-01 ~]#
> >> and checking sizes on servers:
> >> stor-a01 (this PG shouldn't be on the same host):
> >> [root@stor-a01 /var/lib/ceph/osd/ceph-0/current]# du -sh 10.3c4_*
> >> 2.4G    10.3c4_head
> >> 0       10.3c4_TEMP
> >> [root@stor-a01 /var/lib/ceph/osd/ceph-109/current]# du -sh 10.3c4_*
> >> 14G     10.3c4_head
> >> 0       10.3c4_TEMP
> >> [root@stor-a01 /var/lib/ceph/osd/ceph-109/current]#
> >> stor-a02:
> >> [root@stor-a02 /var/lib/ceph/osd/ceph-9/current]# du -sh 10.3c4_*
> >> 14G     10.3c4_head
> >> 0       10.3c4_TEMP
> >> [root@stor-a02 /var/lib/ceph/osd/ceph-9/current]#
> >> stor-b02:
> >> [root@stor-b02 /var/lib/ceph/osd/ceph-117/current]# du -sh 10.3c4_*
> >> zsh: no matches found: 10.3c4_*
> >>
> >> information about ceph:
> >> [root@ceph-mon-01 ~]# ceph versions
> >> {
> >>     "mon": {
> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217=
) luminous (stable)": 3
> >>     },
> >>     "mgr": {
> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217=
) luminous (stable)": 3
> >>     },
> >>     "osd": {
> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217=
) luminous (stable)": 144
> >>     },
> >>     "mds": {},
> >>     "rbd-mirror": {
> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217=
) luminous (stable)": 3
> >>     },
> >>     "rgw": {
> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217=
) luminous (stable)": 6
> >>     },
> >>     "overall": {
> >>         "ceph version 12.2.9 (9e300932ef8a8916fb3fda78c58691a6ab0f4217=
) luminous (stable)": 159
> >>     }
> >> }
> >>
> >> crushmap: https://pastebin.com/cpC2WmyS
> >> ceph osd tree: https://pastebin.com/XvZ2cNZZ
> >>
> >> I'm  cross-posting this do devel because maybe there is some known bug
> >> in  this  particular  version  of  ceph,  and  You  could  point  some
> >> directions to fix this problem.
> >>
> >> --
> >> Regards
> >> Lukasz
> >>
>
>
>
> --
> Pozdrowienia,
>  Luk
>
