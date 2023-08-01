Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C067E76AB26
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Aug 2023 10:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjHAIef (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Aug 2023 04:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjHAIec (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Aug 2023 04:34:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0945D1B6
        for <ceph-devel@vger.kernel.org>; Tue,  1 Aug 2023 01:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690878824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U10B98Pu0R9R3HFUTiKyBXM5NGzVEuqPCXUhwAIdJEU=;
        b=Uc0OuD66ZgVwvo3/NcZ/kmTopCXrAq/WDGoM8H7VoXJi8skGmfC3K5MQKwxw7Ue2WGMCzG
        7EUcy0RjJJ9Dulm4H93wojWhAiyOvoARL8QMwUjo39PFe6B8gNbEq1KxJQ/2KllBxHNQ4x
        PvvaTYB81FkpprrF4ugc4G8cZ4N9dCk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-jajTZ4T3MWu8rJWid_gqNw-1; Tue, 01 Aug 2023 04:33:42 -0400
X-MC-Unique: jajTZ4T3MWu8rJWid_gqNw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-993c2d9e496so325302966b.0
        for <ceph-devel@vger.kernel.org>; Tue, 01 Aug 2023 01:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690878821; x=1691483621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U10B98Pu0R9R3HFUTiKyBXM5NGzVEuqPCXUhwAIdJEU=;
        b=ZVGetAP3hwHV9pKOWCnuRlR9hmpwWmKY3m2F4+JTtwEaWfuMb50O9ni0NSXw6L1loB
         iwcNlirvg9v/eyM+DvkK+IA3Km6q+y3fa7+fk/Bqr5H5PDgML4j+uzSjbQ3nKo8PjZgp
         I9Wwjg9A/eY3hxDMBGBQNmXIyI0Lnh1x4SUCUMmPNquklhuK9wOT1PUMWDOJPLLdWe2K
         F2UYtc5Rci1e34OfN4iT8fJARH0G0lcie/xvvvCVFROI4gHEGjbeevpoGnMpca2IGoFm
         g4W43DnE69+gGH44cA2wvDfoJLp+czTZeBHeSWLakcYpf1r6JICc9B7K0puX4UIB6f0J
         HW3A==
X-Gm-Message-State: ABy/qLZRR8elya8WzWd+CyZtc0EsWdCLoKSJoqu7eWhwBW/nzKrLK5/4
        ts0hmK9AUDZ/YZC3k9su8z5wwIXvMTWt2TEDz2SyTlic25r2KloR7O7+SHHFeEmvWyZJ2z2YsAb
        QHXt5bbhTGxT8xhlq9Bv1QNJelbg35+Js+ADKPA==
X-Received: by 2002:a17:907:77cd:b0:98d:4000:1bf9 with SMTP id kz13-20020a17090777cd00b0098d40001bf9mr1969986ejc.65.1690878821772;
        Tue, 01 Aug 2023 01:33:41 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFNMNRn1iF2TmzoOed+zM+IVfM+BzLPy7r5L/98BVYcEiwbUAOLvgT0xb7ZuUsPU5TczZEAeV1Gwsx8RJCh/wQ=
X-Received: by 2002:a17:907:77cd:b0:98d:4000:1bf9 with SMTP id
 kz13-20020a17090777cd00b0098d40001bf9mr1969966ejc.65.1690878821385; Tue, 01
 Aug 2023 01:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230725040359.363444-1-xiubli@redhat.com> <CAED=hWDNP2AsnqHWxyHxuQij1KWVoT+oEETD7r3GqtBP=k7yBA@mail.gmail.com>
 <b4766f81-faf6-2df5-8fea-51b0c5a772ab@redhat.com>
In-Reply-To: <b4766f81-faf6-2df5-8fea-51b0c5a772ab@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 1 Aug 2023 14:03:05 +0530
Message-ID: <CAED=hWCT6aSQLkk9Go5WhXxWTZxUW3mVnibh70G=2QFb=2LkjQ@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: defer stopping the mdsc delayed_work
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Mon, Jul 31, 2023 at 5:29=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 7/31/23 19:47, Milind Changire wrote:
> > On Tue, Jul 25, 2023 at 9:36=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> Flushing the dirty buffer may take a long time if the Rados is
> >> overloaded or if there is network issue. So we should ping the
> >> MDSs periodically to keep alive, else the MDS will blocklist
> >> the kclient.
> >>
> >> Cc: stable@vger.kernel.org
> >> Cc: Venky Shankar <vshankar@redhat.com>
> >> URL: https://tracker.ceph.com/issues/61843
> >> Reviewed-by: Milind Changire <mchangir@redhat.com>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>
> >> V3:
> >> - Rebased to the master branch
> >>
> >>
> >>   fs/ceph/mds_client.c |  4 ++--
> >>   fs/ceph/mds_client.h |  5 +++++
> >>   fs/ceph/super.c      | 10 ++++++++++
> >>   3 files changed, 17 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index 66048a86c480..5fb367b1d4b0 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -4764,7 +4764,7 @@ static void delayed_work(struct work_struct *wor=
k)
> >>
> >>          dout("mdsc delayed_work\n");
> >>
> >> -       if (mdsc->stopping)
> >> +       if (mdsc->stopping >=3D CEPH_MDSC_STOPPING_FLUSHED)
> >>                  return;
> > Do we want to continue to accept/perform delayed work when
> > mdsc->stopping is set to CEPH_MDSC_STOPPING_BEGIN ?
> >
> > I thought setting the STOPPING_BEGIN flag would immediately bar any
> > further new activity and STOPPING_FLUSHED would mark safe deletion of
> > the superblock.
>
> Yes,  we need.
>
> Locally I can reproduce this very easy with fsstress.sh script, please
> see https://tracker.ceph.com/issues/61843#note-1.
>
> That's because when umounting and flushing the dirty buffer it could be
> blocked by the Rados dues to the lower disk space or MM reasons. And
> during this we need to ping MDS to keep alive to make sure the MDS won't
> evict us before we close the sessions later.
>
> Thanks
>
> - Xiubo
>
> >
> >
> >>          mutex_lock(&mdsc->mutex);
> >> @@ -4943,7 +4943,7 @@ void send_flush_mdlog(struct ceph_mds_session *s=
)
> >>   void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
> >>   {
> >>          dout("pre_umount\n");
> >> -       mdsc->stopping =3D 1;
> >> +       mdsc->stopping =3D CEPH_MDSC_STOPPING_BEGIN;
> >>
> >>          ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
> >>          ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
> >> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> >> index 724307ff89cd..86d2965e68a1 100644
> >> --- a/fs/ceph/mds_client.h
> >> +++ b/fs/ceph/mds_client.h
> >> @@ -380,6 +380,11 @@ struct cap_wait {
> >>          int                     want;
> >>   };
> >>
> >> +enum {
> >> +       CEPH_MDSC_STOPPING_BEGIN =3D 1,
> >> +       CEPH_MDSC_STOPPING_FLUSHED =3D 2,
> >> +};
> >> +
> >>   /*
> >>    * mds client state
> >>    */
> >> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> >> index 3fc48b43cab0..a5f52013314d 100644
> >> --- a/fs/ceph/super.c
> >> +++ b/fs/ceph/super.c
> >> @@ -1374,6 +1374,16 @@ static void ceph_kill_sb(struct super_block *s)
> >>          ceph_mdsc_pre_umount(fsc->mdsc);
> >>          flush_fs_workqueues(fsc);
> >>
> >> +       /*
> >> +        * Though the kill_anon_super() will finally trigger the
> >> +        * sync_filesystem() anyway, we still need to do it here
> >> +        * and then bump the stage of shutdown to stop the work
> >> +        * queue as earlier as possible.
> >> +        */
> >> +       sync_filesystem(s);
> >> +
> >> +       fsc->mdsc->stopping =3D CEPH_MDSC_STOPPING_FLUSHED;
> >> +
> >>          kill_anon_super(s);
> >>
> >>          fsc->client->extra_mon_dispatch =3D NULL;
> >> --
> >> 2.39.1
> >>
> >
>


--=20
Milind

