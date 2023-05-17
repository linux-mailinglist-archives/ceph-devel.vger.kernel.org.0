Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FC1706C30
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjEQPGy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 11:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbjEQPGa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 11:06:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B98869E
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 08:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684335877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUDwJhebZTosFntvnSdZ7yumyqgu5bdd5FkSTUFEzlY=;
        b=RJs58Y1xcVJI7LyL0BlNiL46JTXe+0HOdEn0IVkSjAhWQHbBkLQavh4r0NGpbhSXV6Gy51
        ltaJTYXDNDMfWimC4fz/e49HstMuoUuSS6lPkIK8SqggenK34WO1veSwRLe+gofyD3ddYV
        9SvzeUH1WaLAUlF7XMRIPxRz3LRhneE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-bgskPmTMMLm-pMdUfMQEkQ-1; Wed, 17 May 2023 11:04:29 -0400
X-MC-Unique: bgskPmTMMLm-pMdUfMQEkQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4f397572596so485068e87.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 08:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684335867; x=1686927867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUDwJhebZTosFntvnSdZ7yumyqgu5bdd5FkSTUFEzlY=;
        b=N0uDRCVTpKu3op3fg7pjfRGP7PrS6Jf6sQZICWx2/9N4+7EogHlhu4BRExr23IqNZP
         hgHC5lAav4CmFZ2mpGTB21rjr+tksRxK/pN7+a1EtbthddXdvkuqS3RkmgOWBiNi4JHa
         QJZH3S1QwFIEk8AyG8ZzwBiRq3rAjhA/K2rauZ2Omf507plkQZSR8amElQNa4t6izc1I
         leQJapOchfxUCifVJah0xocZKZgCjl+/Qm5p3bmjtcBsHXIKtTPIm0RsH71f2p5rF8au
         yHUgTOBxeIiWRY3YyrwOXhpgqNrQKf/TAqsiqxTqsqDrzMrmI9+svwtBfv8yDrUY9Ori
         jGxg==
X-Gm-Message-State: AC+VfDxgIdFSOc4GJ2+aUvlnerY8xNXHivF4n4QPC8sxjppGodpu4NyU
        lyN2cvM41SQN0ZUrCit9dacOy4qyaaRzfkS5oo6Jx0nyRXrdL+ahdcCFS514IOWHQnGuA5TIWKX
        ym3AlaLjAwoZJanDv4L/ZzpMUDZOsOryV6TTInA==
X-Received: by 2002:ac2:5dc4:0:b0:4f3:93d8:689e with SMTP id x4-20020ac25dc4000000b004f393d8689emr359358lfq.14.1684335866786;
        Wed, 17 May 2023 08:04:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4uWSD95r1ywc7R2okAS3zWLwYo0UZafSPtKwj38y2rreDfrP/XDKT0mQ2IpBnYVcIIkA6O9FE5OovH3SfE2dI=
X-Received: by 2002:ac2:5dc4:0:b0:4f3:93d8:689e with SMTP id
 x4-20020ac25dc4000000b004f393d8689emr359347lfq.14.1684335866325; Wed, 17 May
 2023 08:04:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com> <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com> <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <CAJ4mKGbp3Csdy56hcnHLam6asCv9tMSANL_YzD6pM+NV3eQicA@mail.gmail.com>
 <CAOi1vP90QTPTtTmjRrskX4WEJKcPs52phS0C383eZxHmG4q5zQ@mail.gmail.com> <CAJ4mKGZUvrVHsEX-==kD9x_ArSL5FD_k0PDmYT4e6mo_80Ah_g@mail.gmail.com>
In-Reply-To: <CAJ4mKGZUvrVHsEX-==kD9x_ArSL5FD_k0PDmYT4e6mo_80Ah_g@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 17 May 2023 08:04:14 -0700
Message-ID: <CAJ4mKGZ8YRyWYry5F8yAGDhpv3X_LkQHj+f9ONXKsrbWSjDVsQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Just to be clear, I'd like the details here so we can see if there are
ways to prevent similar issues in the future, which I haven't heard
anybody talk about. :)

On Wed, May 17, 2023 at 8:03=E2=80=AFAM Gregory Farnum <gfarnum@redhat.com>=
 wrote:
>
> On Wed, May 17, 2023 at 7:27=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com>=
 wrote:
> >
> > On Wed, May 17, 2023 at 3:59=E2=80=AFPM Gregory Farnum <gfarnum@redhat.=
com> wrote:
> > >
> > > On Wed, May 17, 2023 at 4:33=E2=80=AFAM Ilya Dryomov <idryomov@gmail.=
com> wrote:
> > > >
> > > > On Wed, May 17, 2023 at 1:04=E2=80=AFPM Xiubo Li <xiubli@redhat.com=
> wrote:
> > > > >
> > > > >
> > > > > On 5/17/23 18:31, Ilya Dryomov wrote:
> > > > > > On Wed, May 17, 2023 at 7:24=E2=80=AFAM <xiubli@redhat.com> wro=
te:
> > > > > >> From: Xiubo Li <xiubli@redhat.com>
> > > > > >>
> > > > > >> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT th=
e
> > > > > >> request may still contain a list of 'split_realms', and we nee=
d
> > > > > >> to skip it anyway. Or it will be parsed as a corrupt snaptrace=
.
> > > > > >>
> > > > > >> Cc: stable@vger.kernel.org
> > > > > >> Cc: Frank Schilder <frans@dtu.dk>
> > > > > >> Reported-by: Frank Schilder <frans@dtu.dk>
> > > > > >> URL: https://tracker.ceph.com/issues/61200
> > > > > >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > >> ---
> > > > > >>   fs/ceph/snap.c | 3 +++
> > > > > >>   1 file changed, 3 insertions(+)
> > > > > >>
> > > > > >> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > > > >> index 0e59e95a96d9..d95dfe16b624 100644
> > > > > >> --- a/fs/ceph/snap.c
> > > > > >> +++ b/fs/ceph/snap.c
> > > > > >> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_cl=
ient *mdsc,
> > > > > >>                                  continue;
> > > > > >>                          adjust_snap_realm_parent(mdsc, child,=
 realm->ino);
> > > > > >>                  }
> > > > > >> +       } else {
> > > > > >> +               p +=3D sizeof(u64) * num_split_inos;
> > > > > >> +               p +=3D sizeof(u64) * num_split_realms;
> > > > > >>          }
> > > > > >>
> > > > > >>          /*
> > > > > >> --
> > > > > >> 2.40.1
> > > > > >>
> > > > > > Hi Xiubo,
> > > > > >
> > > > > > This code appears to be very old -- it goes back to the initial=
 commit
> > > > > > 963b61eb041e ("ceph: snapshot management") in 2009.  Do you hav=
e an
> > > > > > explanation for why this popped up only now?
> > > > >
> > > > > As I remembered we hit this before in one cu BZ last year, but I
> > > > > couldn't remember exactly which one.  But I am not sure whether @=
Jeff
> > > > > saw this before I joint ceph team.
> > > > >
> > > > >
> > > > > > Has MDS always been including split_inos and split_realms array=
s in
> > > > > > !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a=
 recent
> > > > > > change, I'd argue that this needs to be addressed on the MDS si=
de.
> > > > >
> > > > > While in MDS side for the _UPDATE op it won't send the 'split_rea=
lm'
> > > > > list just before the commit in 2017:
> > > > >
> > > > > commit 93e7267757508520dfc22cff1ab20558bd4a44d4
> > > > > Author: Yan, Zheng <zyan@redhat.com>
> > > > > Date:   Fri Jul 21 21:40:46 2017 +0800
> > > > >
> > > > >      mds: send snap related messages centrally during mds recover=
y
> > > > >
> > > > >      sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages =
to
> > > > >      clients centrally in MDCache::open_snaprealms()
> > > > >
> > > > >      Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > > >
> > > > > Before this commit it will only send the 'split_realm' list for t=
he
> > > > > _SPLIT op.
> > > >
> > > > It sounds like we have the culprit.  This should be treated as
> > > > a regression and fixed on the MDS side.  I don't see a justificatio=
n
> > > > for putting useless data on the wire.
> > >
> > > I don't really understand this viewpoint. We can treat it as an MDS
> > > regression if we want, but it's a six-year-old patch so this is in
> > > nearly every version of server code anybody's running. Why wouldn't w=
e
> > > fix it on both sides?
> >
> > Well, if I didn't speak up chances are we wouldn't have identified the
> > regression in the MDS at all.  People seem to have this perception that
> > the client is somehow "easier" to fix, assume that the server is always
> > doing the right thing and default to patching the client.  I'm just
> > trying to push back on that.
> >
> > In this particular case, after understanding the scope of the issue
> > _and_ getting a committal for the MDS side fix, I approved taking the
> > kernel client patch in an earlier reply.
> >
> > >
> > > On Wed, May 17, 2023 at 4:07=E2=80=AFAM Xiubo Li <xiubli@redhat.com> =
wrote:
> > > > And if the split_realm number equals to sizeof(ceph_mds_snap_realm)=
 +
> > > > extra snap buffer size by coincidence, the above 'corrupted' snaptr=
ace
> > > > will be parsed by kclient too and kclient won't give any warning, b=
ut it
> > > > will corrupted the snaprealm and capsnap info in kclient.
> > >
> > > I'm a bit confused about this patch, but I also don't follow the
> > > kernel client code much so please forgive my ignorance. The change
> > > you've made is still only invoked inside of the CEPH_SNAP_OP_SPLIT
> > > case, so clearly the kclient *mostly* does the right thing when these
> >
> > No, it's invoked outside: it introduces a "op !=3D CEPH_SNAP_OP_SPLIT"
> > branch.
>
> Oh I mis-parsed the braces/spacing there.
>
> I'm still not getting how the precise size is causing the problem =E2=80=
=94
> obviously this isn't an unheard-of category of issue, but the fact
> that it works until the count matches a magic number is odd. Is that
> ceph_decode_need macro being called from ceph_update_snap_trace just
> skipping over the split data somehow? *puzzled*
> -Greg
>
> >
> > Thanks,
> >
> >                 Ilya
> >

