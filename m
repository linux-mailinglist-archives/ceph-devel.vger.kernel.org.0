Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC28706910
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 15:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjEQNMH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 09:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjEQNME (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 09:12:04 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB901FFE;
        Wed, 17 May 2023 06:12:00 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9661047f8b8so129454266b.0;
        Wed, 17 May 2023 06:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684329119; x=1686921119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7ZgcL6h5Mg1yAyhBzh4UAhK5oggXXVLaQZpbmvUGz8=;
        b=WkPHQZvp8+aq2hjh+SbhPb+9jXq3b6WfHm4jHanqPlilXuWUGDS67E/DlSdx6jBVRM
         H7ZNJSfTfG3lZkgDfCb8uqGm+dIwB6uzMMfTWkYcTzU/SNtH9wd2Y/ohId5yoNiqNVw1
         jPPPx22C1zVYt0WaobDPj/JXV38ssuScxDbjH3R4iVHGj1zHXYYRmFwNfiu3m/d33Kcy
         NCDRVuyVD3day1/4QiKLCLkldCIgWeOyUKK55BigUoClIRMEEc4nsdFERUOYvIWMxnm/
         Pq3qn2kchNJpCXE33kiVo0jlHXYUPZD9AppNj/VmfS6OeJLvRbgUeQky5++JpNTMCBVg
         UHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684329119; x=1686921119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7ZgcL6h5Mg1yAyhBzh4UAhK5oggXXVLaQZpbmvUGz8=;
        b=CPBwox7FPegmqHU+HFSrj0RSwoF077C/1jaNBwbiWjDlVFrsCjo9qPcqqPGDfGnj3X
         0b9pRm8E702d7uzSb0EwHAlEi2RdVYt1K8lSU5klCrpixntCMjAL7uxtxvp5AfysVehM
         LI+Zeh/P6uDxnSVyg1x0TWijLjBqZ4J7io66S7JYWxCLmvx6rK3AGTxUXlWop8fIZv4y
         9QHFW7IprtLgt8aE6wga7Cc8GKMOMWYk4/rb6NcCRMN8iEggmPxRNxZKNtJYbOkwXbWD
         QszgznFqIbiR4Z4gLDBGrSWFBvw8APZHu42pahkr0q1xezLZj7GoY+h+H+fdXpWmRfCT
         3M3A==
X-Gm-Message-State: AC+VfDy7qGGoefJcgnB8QLIMjSdKIZPQigzuN5iY6j8QvtW7vVGYudC4
        aQbkiPmP6QPHYrdBhWoy2tZjxjtx62cDR8OaJaw=
X-Google-Smtp-Source: ACHHUZ4mZGE+mUG2VZewQAUyc5FMTD8mI8hQ8HQtbkuoCL59G5fyACqn45CUuxalH4pbED04+1O9YO13rb2FCRzPqoY=
X-Received: by 2002:a17:906:974e:b0:96f:181b:87d3 with SMTP id
 o14-20020a170906974e00b0096f181b87d3mr463785ejy.37.1684329118657; Wed, 17 May
 2023 06:11:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com> <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com> <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <11105fba-dce6-d54e-a75d-2673e4b5f3cf@redhat.com>
In-Reply-To: <11105fba-dce6-d54e-a75d-2673e4b5f3cf@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 17 May 2023 15:11:46 +0200
Message-ID: <CAOi1vP-xT56QYsne-n-fjSoDitEbeaEQNuxA_sKKbR=M+V7baA@mail.gmail.com>
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 17, 2023 at 2:46=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/17/23 19:29, Ilya Dryomov wrote:
> > On Wed, May 17, 2023 at 1:04=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wr=
ote:
> >>
> >> On 5/17/23 18:31, Ilya Dryomov wrote:
> >>> On Wed, May 17, 2023 at 7:24=E2=80=AFAM <xiubli@redhat.com> wrote:
> >>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>
> >>>> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
> >>>> request may still contain a list of 'split_realms', and we need
> >>>> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
> >>>>
> >>>> Cc: stable@vger.kernel.org
> >>>> Cc: Frank Schilder <frans@dtu.dk>
> >>>> Reported-by: Frank Schilder <frans@dtu.dk>
> >>>> URL: https://tracker.ceph.com/issues/61200
> >>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>>> ---
> >>>>    fs/ceph/snap.c | 3 +++
> >>>>    1 file changed, 3 insertions(+)
> >>>>
> >>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> >>>> index 0e59e95a96d9..d95dfe16b624 100644
> >>>> --- a/fs/ceph/snap.c
> >>>> +++ b/fs/ceph/snap.c
> >>>> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client *=
mdsc,
> >>>>                                   continue;
> >>>>                           adjust_snap_realm_parent(mdsc, child, real=
m->ino);
> >>>>                   }
> >>>> +       } else {
> >>>> +               p +=3D sizeof(u64) * num_split_inos;
> >>>> +               p +=3D sizeof(u64) * num_split_realms;
> >>>>           }
> >>>>
> >>>>           /*
> >>>> --
> >>>> 2.40.1
> >>>>
> >>> Hi Xiubo,
> >>>
> >>> This code appears to be very old -- it goes back to the initial commi=
t
> >>> 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
> >>> explanation for why this popped up only now?
> >> As I remembered we hit this before in one cu BZ last year, but I
> >> couldn't remember exactly which one.  But I am not sure whether @Jeff
> >> saw this before I joint ceph team.
> >>
> >>
> >>> Has MDS always been including split_inos and split_realms arrays in
> >>> !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a recen=
t
> >>> change, I'd argue that this needs to be addressed on the MDS side.
> >> While in MDS side for the _UPDATE op it won't send the 'split_realm'
> >> list just before the commit in 2017:
> >>
> >> commit 93e7267757508520dfc22cff1ab20558bd4a44d4
> >> Author: Yan, Zheng <zyan@redhat.com>
> >> Date:   Fri Jul 21 21:40:46 2017 +0800
> >>
> >>       mds: send snap related messages centrally during mds recovery
> >>
> >>       sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
> >>       clients centrally in MDCache::open_snaprealms()
> >>
> >>       Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> >>
> >> Before this commit it will only send the 'split_realm' list for the
> >> _SPLIT op.
> > It sounds like we have the culprit.  This should be treated as
> > a regression and fixed on the MDS side.  I don't see a justification
> > for putting useless data on the wire.
>
> But we still need this patch to make it to work with the old ceph release=
s.

This is debatable:

- given that no one noticed this for so long, the likelihood of MDS
  sending a CEPH_SNAP_OP_UPDATE message with bogus split_inos and
  split_realms arrays is very low

- MDS side fix would be backported to supported Ceph releases

- people who are running unsupported Ceph releases (i.e. aren't
  updating) are unlikely to be diligently updating their kernel clients

Thanks,

                Ilya
