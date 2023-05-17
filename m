Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C869F70689A
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 14:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjEQMtt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 08:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjEQMtp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 08:49:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA74A2105
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 05:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684327738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qp4elNtVUaDtapAhLrVgk2ErVjPAY0DdHMicyJlbfXU=;
        b=XRuczi2J/LUZ608bg0KX+Qtk2YJ17n4mTlXbtL8ixipo82YyOvW6iw+av4voq6CNfqy1RL
        a3m31NOXbrfrCQ1Bx+XyT7ni17vf93yIdoOSJHS97HiHtUY/b7rp9C56dIKM4xnv/gTzZ4
        ZbPr/Z8IF9wXZx5IcQrADwZ3hscSNPc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-IbZV5dZHPwO-8ttTi2UC_A-1; Wed, 17 May 2023 08:48:57 -0400
X-MC-Unique: IbZV5dZHPwO-8ttTi2UC_A-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-50bffc723c5so734485a12.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 05:48:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684327735; x=1686919735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qp4elNtVUaDtapAhLrVgk2ErVjPAY0DdHMicyJlbfXU=;
        b=LT5ewKZ5eUBvm0CFc2SyHKa8uPKnmj+WH46ZeYXIcZS5ZIGPQcYoS6f11HQEhko7mU
         i3SIBQ1w81io0jyb8NgkZ1lQrgzUOYZPdaZtzE/z+v4XCB2m+vmz6mRYK5ORO+Ac+W6Q
         BH8+VQGWuqJz0z6hznQrWiDOB7Ih3XoZV0kxGVSRJe0CTaBedldRQXM+CA3Hc+H1xTDy
         5VolpEClmxv/P006fU/tIX+/E4sV2zwmOxjLSW/OJbhWO+2DUMuvaCIDoKiveSEg8/jD
         n0z9npq4zgpjjdjRm+PUk1jEKMN2qBH0a3NUlPO3A84h6KTpLyR8BILKBmJAFtPcHtNL
         ZIiA==
X-Gm-Message-State: AC+VfDxW8tzYn+6jJx68rVE/Aqh0hw2ys2CBWmMRTvMQQwODW+H3Vftp
        x0GYm5vkUJUS3L+ayIHeZl10WH2ZWAqcUw5ON1dFSfRwmlXno3/E47zv/3VTwjSck+agc4PN7ce
        VXyPq8LaKkX+N/d9t/XXtCIz8oVnHBRXx6JCvpTXnKsWFGw==
X-Received: by 2002:a17:907:2687:b0:94e:16d:4bf1 with SMTP id bn7-20020a170907268700b0094e016d4bf1mr33867700ejc.66.1684327735118;
        Wed, 17 May 2023 05:48:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5YF3okwUQI7AX+jqhROqPX7MRu3Af7LcygXAevqF/dv7mKXvTHVdZxs5QVexKbpLPIHoq54ruYgBvPsaJbBmk=
X-Received: by 2002:a17:907:2687:b0:94e:16d:4bf1 with SMTP id
 bn7-20020a170907268700b0094e016d4bf1mr33867684ejc.66.1684327734769; Wed, 17
 May 2023 05:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com> <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com> <d6ae6f9e-07f5-0120-2cc6-b5f3f2ddca5f@redhat.com>
In-Reply-To: <d6ae6f9e-07f5-0120-2cc6-b5f3f2ddca5f@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 17 May 2023 18:18:18 +0530
Message-ID: <CACPzV1=BUwKBBbThawt-PnJRoKnvwCNAd9AGPSH2mHVW_6zSZw@mail.gmail.com>
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hey Xiubo,

On Wed, May 17, 2023 at 4:45=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/17/23 19:04, Xiubo Li wrote:
> >
> > On 5/17/23 18:31, Ilya Dryomov wrote:
> >> On Wed, May 17, 2023 at 7:24=E2=80=AFAM <xiubli@redhat.com> wrote:
> >>> From: Xiubo Li <xiubli@redhat.com>
> >>>
> >>> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
> >>> request may still contain a list of 'split_realms', and we need
> >>> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
> >>>
> >>> Cc: stable@vger.kernel.org
> >>> Cc: Frank Schilder <frans@dtu.dk>
> >>> Reported-by: Frank Schilder <frans@dtu.dk>
> >>> URL: https://tracker.ceph.com/issues/61200
> >>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>> ---
> >>>   fs/ceph/snap.c | 3 +++
> >>>   1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> >>> index 0e59e95a96d9..d95dfe16b624 100644
> >>> --- a/fs/ceph/snap.c
> >>> +++ b/fs/ceph/snap.c
> >>> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client
> >>> *mdsc,
> >>>                                  continue;
> >>>                          adjust_snap_realm_parent(mdsc, child,
> >>> realm->ino);
> >>>                  }
> >>> +       } else {
> >>> +               p +=3D sizeof(u64) * num_split_inos;
> >>> +               p +=3D sizeof(u64) * num_split_realms;
> >>>          }
> >>>
> >>>          /*
> >>> --
> >>> 2.40.1
> >>>
> >> Hi Xiubo,
> >>
> >> This code appears to be very old -- it goes back to the initial commit
> >> 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
> >> explanation for why this popped up only now?
> >
> > As I remembered we hit this before in one cu BZ last year, but I
> > couldn't remember exactly which one.  But I am not sure whether @Jeff
> > saw this before I joint ceph team.
> >
> @Venky,
>
> Do you remember which one ? As I remembered this is why we fixed the
> snaptrace issue by blocking all the IOs and at the same time
> blocklisting the kclient before.
>
> Before the kcleint won't dump the corrupted msg and we don't know what
> was wrong with the msg and also we added code to dump the msg in the
> above fix.

The "corrupted" snaptrace issue happened just after the mds asserted
hitting the metadata corruption (dentry first corrupted) and it
_seemed_ that this corruption somehow triggered a corrupted snaptrace
to be sent to the client.

>
> Thanks
>
> - Xiubo
>
> >
> >> Has MDS always been including split_inos and split_realms arrays in
> >> !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a recent
> >> change, I'd argue that this needs to be addressed on the MDS side.
> >
> > While in MDS side for the _UPDATE op it won't send the 'split_realm'
> > list just before the commit in 2017:
> >
> > commit 93e7267757508520dfc22cff1ab20558bd4a44d4
> > Author: Yan, Zheng <zyan@redhat.com>
> > Date:   Fri Jul 21 21:40:46 2017 +0800
> >
> >     mds: send snap related messages centrally during mds recovery
> >
> >     sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
> >     clients centrally in MDCache::open_snaprealms()
> >
> >     Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> >
> > Before this commit it will only send the 'split_realm' list for the
> > _SPLIT op.
> >
> >
> > The following the snaptrace:
> >
> > [Wed May 10 16:03:06 2023] header: 00000000: 05 00 00 00 00 00 00 00
> > 00 00 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023] header: 00000010: 12 03 7f 00 01 00 00 01
> > 00 00 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023] header: 00000020: 00 00 00 00 02 01 00 00
> > 00 00 00 00 00 01 00 00  ................
> > [Wed May 10 16:03:06 2023] header: 00000030: 00 98 0d 60
> > 93                                   ...`.
> > [Wed May 10 16:03:06 2023]  front: 00000000: 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00 00 00  ................ <<=3D=3D The op is 0, which i=
s
> > 'CEPH_SNAP_OP_UPDATE'
> > [Wed May 10 16:03:06 2023]  front: 00000010: 0c 00 00 00 88 00 00 00
> > d1 c0 71 38 00 01 00 00  ..........q8....           <<=3D=3D The '0c' i=
s
> > the split_realm number
> > [Wed May 10 16:03:06 2023]  front: 00000020: 22 c8 71 38 00 01 00 00
> > d7 c7 71 38 00 01 00 00  ".q8......q8....       <<=3D=3D All the 'q8' a=
re
> > the ino#
> > [Wed May 10 16:03:06 2023]  front: 00000030: d9 c7 71 38 00 01 00 00
> > d4 c7 71 38 00 01 00 00  ..q8......q8....
> > [Wed May 10 16:03:06 2023]  front: 00000040: f1 c0 71 38 00 01 00 00
> > d4 c0 71 38 00 01 00 00  ..q8......q8....
> > [Wed May 10 16:03:06 2023]  front: 00000050: 20 c8 71 38 00 01 00 00
> > 1d c8 71 38 00 01 00 00   .q8......q8....
> > [Wed May 10 16:03:06 2023]  front: 00000060: ec c0 71 38 00 01 00 00
> > d6 c0 71 38 00 01 00 00  ..q8......q8....
> > [Wed May 10 16:03:06 2023]  front: 00000070: ef c0 71 38 00 01 00 00
> > 6a 11 2d 1a 00 01 00 00  ..q8....j.-.....
> > [Wed May 10 16:03:06 2023]  front: 00000080: 01 00 00 00 00 00 00 00
> > 01 00 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023]  front: 00000090: ee 01 00 00 00 00 00 00
> > 01 00 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023]  front: 000000a0: 00 00 00 00 00 00 00 00
> > 01 00 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023]  front: 000000b0: 01 09 00 00 00 00 00 00
> > 00 00 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023]  front: 000000c0: 01 00 00 00 00 00 00 00
> > 02 09 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023]  front: 000000d0: 05 00 00 00 00 00 00 00
> > 01 09 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023]  front: 000000e0: ff 08 00 00 00 00 00 00
> > fd 08 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023]  front: 000000f0: fb 08 00 00 00 00 00 00
> > f9 08 00 00 00 00 00 00  ................
> > [Wed May 10 16:03:06 2023] footer: 00000000: ca 39 06 07 00 00 00 00
> > 00 00 00 00 42 06 63 61  .9..........B.ca
> > [Wed May 10 16:03:06 2023] footer: 00000010: 7b 4b 5d 2d
> > 05                                   {K]-.
> >
> >
> > And if the split_realm number equals to sizeof(ceph_mds_snap_realm) +
> > extra snap buffer size by coincidence, the above 'corrupted' snaptrace
> > will be parsed by kclient too and kclient won't give any warning, but
> > it will corrupted the snaprealm and capsnap info in kclient.
> >
> >
> > Thanks
> >
> > - Xiubo
> >
> >
> >> Thanks,
> >>
> >>                  Ilya
> >>
>


--=20
Cheers,
Venky

