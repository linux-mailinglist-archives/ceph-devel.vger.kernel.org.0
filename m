Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37746706A59
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 15:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjEQN7u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 09:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjEQN7t (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 09:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A65530CB
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 06:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684331952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rhwjcPjf7tMysXgyygZE3d8Tay0T8zNYLAk8/k5TFSU=;
        b=HS0PgMz4N3eW7kek/hibnwYx3Q5lrxobLTnjg8MtXgVP4T/+ecqGEM/S5wJLX68+2INS4u
        U9h1PYGNWBuKEwA3HCLf+MbgadJtj0h+IFlQo91znYrgHtCdCqLlHT1Rjfe4IZ36V5jvbf
        trdxXq3c15agR6RZ6YqNB8kJ4zCqlbs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-uQha9FtiObqgHbj-AVo_xw-1; Wed, 17 May 2023 09:59:11 -0400
X-MC-Unique: uQha9FtiObqgHbj-AVo_xw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ac828fcd98so3462971fa.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 06:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684331949; x=1686923949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rhwjcPjf7tMysXgyygZE3d8Tay0T8zNYLAk8/k5TFSU=;
        b=TyburqIX3pNMQxqW5E2vfpSmPYhB15/F74LPibjuZoxSqLKFqKROBoh9qSKtoZVYo5
         8MtWY8+8mOfCFbTIDiWdD+T2Xk5QkKtyf26ArdPb7kTdC2f0Vdz6VmJLvfiD5xvACToM
         +ulJr2UtluDT0aA3IPZRjLW/Fe/BQdw2RGt/DKnq5mK/t+tZMP18pTh+BnQjEbTIP8XF
         GvkMFUqVy2OrCB/6baYJaVF7XvlPwndGRTsqQDJEm3SS1BQfBB9zk1+/s0d98tnh368T
         sFw6frA+DzBvn9vr96FwV1JdnZ1MhP2sfPwmtaTwJHq8qHvQgke78v5YrU5CCZeAUCEy
         6NCw==
X-Gm-Message-State: AC+VfDxgZYURFjW9EQOZDpTNLX/wkSOmguHV1AfpWfZi/m+nAF8ORAIS
        O6m/9PkTKGQFcfBXZXSnS0XpvQUsFYdFdNMfhn7dlDqEXBwB/ZsnP+nPIbmuevdjeR2ryg3zmT5
        4YrEMSt5MqaZ5i0h+8D5rOOApAQ4VY4qRl+s9Kw==
X-Received: by 2002:a2e:9818:0:b0:2a8:c842:d30c with SMTP id a24-20020a2e9818000000b002a8c842d30cmr10737293ljj.44.1684331949285;
        Wed, 17 May 2023 06:59:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6A4nya5GbKKhd1itouA04xyt4vN3bBG8kX9xbaLugA9xdc4LvOt8/p/tlRbbPnvcNaHQ0fwF5mUrVAf5/tc3g=
X-Received: by 2002:a2e:9818:0:b0:2a8:c842:d30c with SMTP id
 a24-20020a2e9818000000b002a8c842d30cmr10737281ljj.44.1684331948783; Wed, 17
 May 2023 06:59:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com> <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com> <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
In-Reply-To: <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 17 May 2023 06:58:57 -0700
Message-ID: <CAJ4mKGbp3Csdy56hcnHLam6asCv9tMSANL_YzD6pM+NV3eQicA@mail.gmail.com>
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
To:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 17, 2023 at 4:33=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com> w=
rote:
>
> On Wed, May 17, 2023 at 1:04=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrot=
e:
> >
> >
> > On 5/17/23 18:31, Ilya Dryomov wrote:
> > > On Wed, May 17, 2023 at 7:24=E2=80=AFAM <xiubli@redhat.com> wrote:
> > >> From: Xiubo Li <xiubli@redhat.com>
> > >>
> > >> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
> > >> request may still contain a list of 'split_realms', and we need
> > >> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
> > >>
> > >> Cc: stable@vger.kernel.org
> > >> Cc: Frank Schilder <frans@dtu.dk>
> > >> Reported-by: Frank Schilder <frans@dtu.dk>
> > >> URL: https://tracker.ceph.com/issues/61200
> > >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > >> ---
> > >>   fs/ceph/snap.c | 3 +++
> > >>   1 file changed, 3 insertions(+)
> > >>
> > >> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > >> index 0e59e95a96d9..d95dfe16b624 100644
> > >> --- a/fs/ceph/snap.c
> > >> +++ b/fs/ceph/snap.c
> > >> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client *=
mdsc,
> > >>                                  continue;
> > >>                          adjust_snap_realm_parent(mdsc, child, realm=
->ino);
> > >>                  }
> > >> +       } else {
> > >> +               p +=3D sizeof(u64) * num_split_inos;
> > >> +               p +=3D sizeof(u64) * num_split_realms;
> > >>          }
> > >>
> > >>          /*
> > >> --
> > >> 2.40.1
> > >>
> > > Hi Xiubo,
> > >
> > > This code appears to be very old -- it goes back to the initial commi=
t
> > > 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
> > > explanation for why this popped up only now?
> >
> > As I remembered we hit this before in one cu BZ last year, but I
> > couldn't remember exactly which one.  But I am not sure whether @Jeff
> > saw this before I joint ceph team.
> >
> >
> > > Has MDS always been including split_inos and split_realms arrays in
> > > !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a recen=
t
> > > change, I'd argue that this needs to be addressed on the MDS side.
> >
> > While in MDS side for the _UPDATE op it won't send the 'split_realm'
> > list just before the commit in 2017:
> >
> > commit 93e7267757508520dfc22cff1ab20558bd4a44d4
> > Author: Yan, Zheng <zyan@redhat.com>
> > Date:   Fri Jul 21 21:40:46 2017 +0800
> >
> >      mds: send snap related messages centrally during mds recovery
> >
> >      sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
> >      clients centrally in MDCache::open_snaprealms()
> >
> >      Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> >
> > Before this commit it will only send the 'split_realm' list for the
> > _SPLIT op.
>
> It sounds like we have the culprit.  This should be treated as
> a regression and fixed on the MDS side.  I don't see a justification
> for putting useless data on the wire.

I don't really understand this viewpoint. We can treat it as an MDS
regression if we want, but it's a six-year-old patch so this is in
nearly every version of server code anybody's running. Why wouldn't we
fix it on both sides?

On Wed, May 17, 2023 at 4:07=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
> And if the split_realm number equals to sizeof(ceph_mds_snap_realm) +
> extra snap buffer size by coincidence, the above 'corrupted' snaptrace
> will be parsed by kclient too and kclient won't give any warning, but it
> will corrupted the snaprealm and capsnap info in kclient.

I'm a bit confused about this patch, but I also don't follow the
kernel client code much so please forgive my ignorance. The change
you've made is still only invoked inside of the CEPH_SNAP_OP_SPLIT
case, so clearly the kclient *mostly* does the right thing when these
"unexpected" SPLIT ops show up. (Which leads me to assume Zheng
checked that the referenced server patch would work, and he was mostly
right.)

So what logic makes it so "split_realm =3D=3D sizeof(ceph_mds_snap_realm)
+ <extra snap buffer size>" is the condition which leads to breakage,
and allows everything else to work?
-Greg

