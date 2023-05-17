Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE69A706B0D
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 16:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjEQO1d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 10:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjEQO1c (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 10:27:32 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEF3768A;
        Wed, 17 May 2023 07:27:30 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96649b412easo129592466b.0;
        Wed, 17 May 2023 07:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684333649; x=1686925649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WawPvaJim75dO9F4vVlCy4pohD178mmSzFE8a9mlSTM=;
        b=crA4cEyPiGKPQQebgHQMvr3oq4MBNXNZxSMT1+1ZBezg52ip7KFfHhkIHlWG/G8htB
         K7PRS+BON3RE/zqDHmsL+KVoCy6I+X6bquI8mCxUoktpK3eBiSIghksF1WRdXhvdLGQb
         huL/HYKxAm5+B2+fSGHsNB5qGooJRllfKu27PamRLXNGSU7P/cQAeZGMZwge6EqxMHGa
         cvVBI11aQ8gKojUyIgSPS8ZKwEaTWik8+1i/u7DB7iA/ht9/1fjFf0YyC4UlqUowuBdD
         S4A25DXTFiTCOrCygvAHAUwy4ZJ+7h2y5XAv78NIECwfIn6dc9fTqvvB5wp8ha1ezHq/
         pyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684333649; x=1686925649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WawPvaJim75dO9F4vVlCy4pohD178mmSzFE8a9mlSTM=;
        b=BN+wttROcfG63HdrVVU3q1pz8CCKtjT07yiSbdEN8a6Z/1gXR7WNpYQabgjH8NEGyW
         5uiL4dX2xo7Y02ILqQ50nrrVWlsosq+wgJJRMLAHBpaJeqdWICij5f5Oe6ebm0IHzyHS
         zWYfal0d1rUdNWW7VYmgMrvysHMmHaQX4Xv67udYa/ppiUImWRt010YhO9ocmRpqpUe2
         Sk72tsXu8C4HvnId8TCm970G5KcDL83A9lbODA1IOcG/6rnKV3xkVrapIHewHk3AW0ha
         7Sx754euDE9GRrbXsS+mKYcqSSGMMwSXxLp4B0x2r3yBDhq+tuZBs1dSbHps6o1pg8ap
         +rzw==
X-Gm-Message-State: AC+VfDzD3r8BT52pzOz3ywQdr8mdPqsFMTO5bctvp+nR4DgmfWRJZt9c
        FAPue3aK83vynjxmqEpbKCWLhW+9PSfbxGCpT1s=
X-Google-Smtp-Source: ACHHUZ6igMn17Jo9QRBZ9EG8Vs0AhyHuU0OkeDu2V8EXLLtp4WdbhivUj91s9rJ7XEUREs6py/3tor92s2ulWIbJ7zA=
X-Received: by 2002:a17:907:318b:b0:94f:956:b3f7 with SMTP id
 xe11-20020a170907318b00b0094f0956b3f7mr35913123ejb.2.1684333648051; Wed, 17
 May 2023 07:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com> <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com> <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <CAJ4mKGbp3Csdy56hcnHLam6asCv9tMSANL_YzD6pM+NV3eQicA@mail.gmail.com>
In-Reply-To: <CAJ4mKGbp3Csdy56hcnHLam6asCv9tMSANL_YzD6pM+NV3eQicA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 17 May 2023 16:27:16 +0200
Message-ID: <CAOi1vP90QTPTtTmjRrskX4WEJKcPs52phS0C383eZxHmG4q5zQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
        jlayton@kernel.org, vshankar@redhat.com, stable@vger.kernel.org,
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

On Wed, May 17, 2023 at 3:59=E2=80=AFPM Gregory Farnum <gfarnum@redhat.com>=
 wrote:
>
> On Wed, May 17, 2023 at 4:33=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com>=
 wrote:
> >
> > On Wed, May 17, 2023 at 1:04=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wr=
ote:
> > >
> > >
> > > On 5/17/23 18:31, Ilya Dryomov wrote:
> > > > On Wed, May 17, 2023 at 7:24=E2=80=AFAM <xiubli@redhat.com> wrote:
> > > >> From: Xiubo Li <xiubli@redhat.com>
> > > >>
> > > >> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
> > > >> request may still contain a list of 'split_realms', and we need
> > > >> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
> > > >>
> > > >> Cc: stable@vger.kernel.org
> > > >> Cc: Frank Schilder <frans@dtu.dk>
> > > >> Reported-by: Frank Schilder <frans@dtu.dk>
> > > >> URL: https://tracker.ceph.com/issues/61200
> > > >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > >> ---
> > > >>   fs/ceph/snap.c | 3 +++
> > > >>   1 file changed, 3 insertions(+)
> > > >>
> > > >> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > >> index 0e59e95a96d9..d95dfe16b624 100644
> > > >> --- a/fs/ceph/snap.c
> > > >> +++ b/fs/ceph/snap.c
> > > >> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client=
 *mdsc,
> > > >>                                  continue;
> > > >>                          adjust_snap_realm_parent(mdsc, child, rea=
lm->ino);
> > > >>                  }
> > > >> +       } else {
> > > >> +               p +=3D sizeof(u64) * num_split_inos;
> > > >> +               p +=3D sizeof(u64) * num_split_realms;
> > > >>          }
> > > >>
> > > >>          /*
> > > >> --
> > > >> 2.40.1
> > > >>
> > > > Hi Xiubo,
> > > >
> > > > This code appears to be very old -- it goes back to the initial com=
mit
> > > > 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
> > > > explanation for why this popped up only now?
> > >
> > > As I remembered we hit this before in one cu BZ last year, but I
> > > couldn't remember exactly which one.  But I am not sure whether @Jeff
> > > saw this before I joint ceph team.
> > >
> > >
> > > > Has MDS always been including split_inos and split_realms arrays in
> > > > !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a rec=
ent
> > > > change, I'd argue that this needs to be addressed on the MDS side.
> > >
> > > While in MDS side for the _UPDATE op it won't send the 'split_realm'
> > > list just before the commit in 2017:
> > >
> > > commit 93e7267757508520dfc22cff1ab20558bd4a44d4
> > > Author: Yan, Zheng <zyan@redhat.com>
> > > Date:   Fri Jul 21 21:40:46 2017 +0800
> > >
> > >      mds: send snap related messages centrally during mds recovery
> > >
> > >      sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
> > >      clients centrally in MDCache::open_snaprealms()
> > >
> > >      Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > >
> > > Before this commit it will only send the 'split_realm' list for the
> > > _SPLIT op.
> >
> > It sounds like we have the culprit.  This should be treated as
> > a regression and fixed on the MDS side.  I don't see a justification
> > for putting useless data on the wire.
>
> I don't really understand this viewpoint. We can treat it as an MDS
> regression if we want, but it's a six-year-old patch so this is in
> nearly every version of server code anybody's running. Why wouldn't we
> fix it on both sides?

Well, if I didn't speak up chances are we wouldn't have identified the
regression in the MDS at all.  People seem to have this perception that
the client is somehow "easier" to fix, assume that the server is always
doing the right thing and default to patching the client.  I'm just
trying to push back on that.

In this particular case, after understanding the scope of the issue
_and_ getting a committal for the MDS side fix, I approved taking the
kernel client patch in an earlier reply.

>
> On Wed, May 17, 2023 at 4:07=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrot=
e:
> > And if the split_realm number equals to sizeof(ceph_mds_snap_realm) +
> > extra snap buffer size by coincidence, the above 'corrupted' snaptrace
> > will be parsed by kclient too and kclient won't give any warning, but i=
t
> > will corrupted the snaprealm and capsnap info in kclient.
>
> I'm a bit confused about this patch, but I also don't follow the
> kernel client code much so please forgive my ignorance. The change
> you've made is still only invoked inside of the CEPH_SNAP_OP_SPLIT
> case, so clearly the kclient *mostly* does the right thing when these

No, it's invoked outside: it introduces a "op !=3D CEPH_SNAP_OP_SPLIT"
branch.

Thanks,

                Ilya
