Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD37706C4D
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 17:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjEQPL6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 11:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjEQPL5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 11:11:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562009EF4
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 08:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684336252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q5RzGFulK/iTq2evWpXpL8oUCIJPeQE5nH6dqifw1CU=;
        b=Iabu6Ube3zmwmXfRr/YxCDX4ljgBOnQb/qD848BDp6fkYB8pOZKAz8JeFUXD3R+GLoNdTn
        FuNKiIBLHbsV2liIbqWMvY542hg9l+/RnEyoMuwPPe9kXcym/VrfjDZoKhM9WVT5xRvVk+
        HDglNPWT0JCdFS34w6TyhffzM2Yv2eo=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-ewQkiSyHN9qYol6N8y3raA-1; Wed, 17 May 2023 11:03:49 -0400
X-MC-Unique: ewQkiSyHN9qYol6N8y3raA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4edd54a0eaeso646310e87.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 08:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684335828; x=1686927828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q5RzGFulK/iTq2evWpXpL8oUCIJPeQE5nH6dqifw1CU=;
        b=PEZkm+0LBMZ21IX0Eh8awfsoLH0BOXx3wmePKQ5angMMZFLiE7EItE9HoMtqGsWAfO
         87GmzBqWJhI2HqQqV/wctjNs6xswv5hA2JLrvt8yx95vV8RVgqPJDDr6SQnYm2cq8gZ2
         nqhmG3aNtQkkDZ+xkhWI+5nRUaCnkBbuoxrcVls67nqTGA0MuqvQSYtYfhYqU8CXcq3P
         wUt0OF6kmtLVYd6AnMKiUucOM4ZtLY9hYZ5M2GM0We8CNeTZuf9htRmH3E5gaLqT8Q38
         0PwBZoAmPI0Cs4iBrY4YGIGDDwelY3ROMyLc0a0OVJ/NREVhJCcwqm7B/bAYx3jUxSrR
         R0uA==
X-Gm-Message-State: AC+VfDwkAB1l8YVlPznBlPSnIWcvkgj9ifEs1hamuuM7z2wPqhzGUrc7
        7Gs5jG6Fe61DjsS8Jo8MSBywc3/aNw+OtNVuxs51nI6hPCG8vBDYnK7EFQ3O7bhYCGMDjSN5nPC
        YC4BCV1JXF+8IBzvnu2I1imDPYo+caYJvsi+f1g==
X-Received: by 2002:ac2:5458:0:b0:4d7:44c9:9f4b with SMTP id d24-20020ac25458000000b004d744c99f4bmr361311lfn.1.1684335827603;
        Wed, 17 May 2023 08:03:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5LXtHar+ysIQvmo0FD8jbym7qM023KL1r+AqdmXTs4zNdKVfcXQqjR1J7e0IzaXRZiNxdm/VFpYCf0ah6xbkI=
X-Received: by 2002:ac2:5458:0:b0:4d7:44c9:9f4b with SMTP id
 d24-20020ac25458000000b004d744c99f4bmr361293lfn.1.1684335827100; Wed, 17 May
 2023 08:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com> <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com> <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <CAJ4mKGbp3Csdy56hcnHLam6asCv9tMSANL_YzD6pM+NV3eQicA@mail.gmail.com> <CAOi1vP90QTPTtTmjRrskX4WEJKcPs52phS0C383eZxHmG4q5zQ@mail.gmail.com>
In-Reply-To: <CAOi1vP90QTPTtTmjRrskX4WEJKcPs52phS0C383eZxHmG4q5zQ@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 17 May 2023 08:03:34 -0700
Message-ID: <CAJ4mKGZUvrVHsEX-==kD9x_ArSL5FD_k0PDmYT4e6mo_80Ah_g@mail.gmail.com>
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 17, 2023 at 7:27=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com> w=
rote:
>
> On Wed, May 17, 2023 at 3:59=E2=80=AFPM Gregory Farnum <gfarnum@redhat.co=
m> wrote:
> >
> > On Wed, May 17, 2023 at 4:33=E2=80=AFAM Ilya Dryomov <idryomov@gmail.co=
m> wrote:
> > >
> > > On Wed, May 17, 2023 at 1:04=E2=80=AFPM Xiubo Li <xiubli@redhat.com> =
wrote:
> > > >
> > > >
> > > > On 5/17/23 18:31, Ilya Dryomov wrote:
> > > > > On Wed, May 17, 2023 at 7:24=E2=80=AFAM <xiubli@redhat.com> wrote=
:
> > > > >> From: Xiubo Li <xiubli@redhat.com>
> > > > >>
> > > > >> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
> > > > >> request may still contain a list of 'split_realms', and we need
> > > > >> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
> > > > >>
> > > > >> Cc: stable@vger.kernel.org
> > > > >> Cc: Frank Schilder <frans@dtu.dk>
> > > > >> Reported-by: Frank Schilder <frans@dtu.dk>
> > > > >> URL: https://tracker.ceph.com/issues/61200
> > > > >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > >> ---
> > > > >>   fs/ceph/snap.c | 3 +++
> > > > >>   1 file changed, 3 insertions(+)
> > > > >>
> > > > >> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > > >> index 0e59e95a96d9..d95dfe16b624 100644
> > > > >> --- a/fs/ceph/snap.c
> > > > >> +++ b/fs/ceph/snap.c
> > > > >> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_clie=
nt *mdsc,
> > > > >>                                  continue;
> > > > >>                          adjust_snap_realm_parent(mdsc, child, r=
ealm->ino);
> > > > >>                  }
> > > > >> +       } else {
> > > > >> +               p +=3D sizeof(u64) * num_split_inos;
> > > > >> +               p +=3D sizeof(u64) * num_split_realms;
> > > > >>          }
> > > > >>
> > > > >>          /*
> > > > >> --
> > > > >> 2.40.1
> > > > >>
> > > > > Hi Xiubo,
> > > > >
> > > > > This code appears to be very old -- it goes back to the initial c=
ommit
> > > > > 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have =
an
> > > > > explanation for why this popped up only now?
> > > >
> > > > As I remembered we hit this before in one cu BZ last year, but I
> > > > couldn't remember exactly which one.  But I am not sure whether @Je=
ff
> > > > saw this before I joint ceph team.
> > > >
> > > >
> > > > > Has MDS always been including split_inos and split_realms arrays =
in
> > > > > !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a r=
ecent
> > > > > change, I'd argue that this needs to be addressed on the MDS side=
.
> > > >
> > > > While in MDS side for the _UPDATE op it won't send the 'split_realm=
'
> > > > list just before the commit in 2017:
> > > >
> > > > commit 93e7267757508520dfc22cff1ab20558bd4a44d4
> > > > Author: Yan, Zheng <zyan@redhat.com>
> > > > Date:   Fri Jul 21 21:40:46 2017 +0800
> > > >
> > > >      mds: send snap related messages centrally during mds recovery
> > > >
> > > >      sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
> > > >      clients centrally in MDCache::open_snaprealms()
> > > >
> > > >      Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > >
> > > > Before this commit it will only send the 'split_realm' list for the
> > > > _SPLIT op.
> > >
> > > It sounds like we have the culprit.  This should be treated as
> > > a regression and fixed on the MDS side.  I don't see a justification
> > > for putting useless data on the wire.
> >
> > I don't really understand this viewpoint. We can treat it as an MDS
> > regression if we want, but it's a six-year-old patch so this is in
> > nearly every version of server code anybody's running. Why wouldn't we
> > fix it on both sides?
>
> Well, if I didn't speak up chances are we wouldn't have identified the
> regression in the MDS at all.  People seem to have this perception that
> the client is somehow "easier" to fix, assume that the server is always
> doing the right thing and default to patching the client.  I'm just
> trying to push back on that.
>
> In this particular case, after understanding the scope of the issue
> _and_ getting a committal for the MDS side fix, I approved taking the
> kernel client patch in an earlier reply.
>
> >
> > On Wed, May 17, 2023 at 4:07=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wr=
ote:
> > > And if the split_realm number equals to sizeof(ceph_mds_snap_realm) +
> > > extra snap buffer size by coincidence, the above 'corrupted' snaptrac=
e
> > > will be parsed by kclient too and kclient won't give any warning, but=
 it
> > > will corrupted the snaprealm and capsnap info in kclient.
> >
> > I'm a bit confused about this patch, but I also don't follow the
> > kernel client code much so please forgive my ignorance. The change
> > you've made is still only invoked inside of the CEPH_SNAP_OP_SPLIT
> > case, so clearly the kclient *mostly* does the right thing when these
>
> No, it's invoked outside: it introduces a "op !=3D CEPH_SNAP_OP_SPLIT"
> branch.

Oh I mis-parsed the braces/spacing there.

I'm still not getting how the precise size is causing the problem =E2=80=94
obviously this isn't an unheard-of category of issue, but the fact
that it works until the count matches a magic number is odd. Is that
ceph_decode_need macro being called from ceph_update_snap_trace just
skipping over the split data somehow? *puzzled*
-Greg

>
> Thanks,
>
>                 Ilya
>

