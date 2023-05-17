Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE552706DF8
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 18:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjEQQTn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 12:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEQQTf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 12:19:35 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A1CA25F;
        Wed, 17 May 2023 09:19:06 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9660af2499dso182729366b.0;
        Wed, 17 May 2023 09:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684340345; x=1686932345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QK50RjOMRVhV3W84fQ0BlWjLb5PrhWxAdRJ7jBMRYHc=;
        b=mx+qG7V8ZtawwikwEj9dsvDBJmpeee/EhlHNYV0oPYs1CIOe3K5kYHtAOjLGyU0gy6
         MSkqQsK/+cimEWytdHfDZ5y0iCu0uf6jTukvNRZve2ygCiWX2A7HlzNADDLAsYpjuMdN
         gVxjeJIWGMV1Kd7dZuojntqr4jfZOWzdYC5+kT37VkQglGwysl8sWVh2TZPpg4C3X51u
         tFly0cfa++mxNuTCKvgV7PbZkD4r095Zt3Xi9xHg3zY+jOaeu2VQOfX7j9QJmHQB3Rjf
         E6llU6NOERntuUjqFArs62jY+fLwGndFM3JmcRHK9lZl+iWtzrb8l/ZAPW3d0zECXrqF
         1Qwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684340345; x=1686932345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QK50RjOMRVhV3W84fQ0BlWjLb5PrhWxAdRJ7jBMRYHc=;
        b=WabCb40W6WiPnz8vChuYGwT5T3m3H0ncnLTcclt1B/23XBcs8Omrg9ikeYc4pqmGGB
         5c85NfQvmKXtnltrIFeoxLi3BCoz7uqeLwRZOPvgvDol1HIKJ3iV2npXw0Th7rikX4qo
         08ZfAxQErxQqCZesUnbR0tcrYex1aG24MgRChse/sp2j7/jUrpMPUc55pJJ/rRPGc7Kv
         U6gqMCwMMUV3qzJvANJlaGXAKL9DbQWDN3Z8kH+dYwPALycM38k3ZeFDVjMSZvL5PUay
         jpmiGpfPM+7cNSBH0HUxuqsuGxXHPyFNhVy0MgAj45x6/jTsIgXzXdyGz0Kze51AGBDE
         UTQQ==
X-Gm-Message-State: AC+VfDyXTPhS0lYLT6bBVHkXPZiUvN6TPaTEOcbIw7R1E+GWF2AzHT+j
        rCd2LWgd+S38FdJ0y0drhWrWYu1uqi7P5f7MSX8=
X-Google-Smtp-Source: ACHHUZ5Q8BcIjXcNkMSUxzks5SyjQv69ksoDtdOQZEe4OBugezyOppQcbeYLsQu8psVu0OPuSrVPyu2H+pu5gSQFytk=
X-Received: by 2002:a17:907:1b12:b0:961:b0:3dfc with SMTP id
 mp18-20020a1709071b1200b0096100b03dfcmr40241209ejc.8.1684340344446; Wed, 17
 May 2023 09:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com> <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com> <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <CAJ4mKGbp3Csdy56hcnHLam6asCv9tMSANL_YzD6pM+NV3eQicA@mail.gmail.com>
 <CAOi1vP90QTPTtTmjRrskX4WEJKcPs52phS0C383eZxHmG4q5zQ@mail.gmail.com> <CAJ4mKGZUvrVHsEX-==kD9x_ArSL5FD_k0PDmYT4e6mo_80Ah_g@mail.gmail.com>
In-Reply-To: <CAJ4mKGZUvrVHsEX-==kD9x_ArSL5FD_k0PDmYT4e6mo_80Ah_g@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 17 May 2023 18:18:52 +0200
Message-ID: <CAOi1vP8dq4_5g4N59Q-HNgBPb=MXEXRr6VNvCswCGH=trOtUyw@mail.gmail.com>
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

On Wed, May 17, 2023 at 5:03=E2=80=AFPM Gregory Farnum <gfarnum@redhat.com>=
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

I'm not sure what count or magic number you are referring to.

AFAIU the issue is that ceph_update_snap_trace() expects to be called
with "p" pointing at ceph_mds_snap_realm encoding.  In the case that is
being fixed it gets called with "p" pointing at "split_inos" array (and
"split_realms" array following that).  The exact check that throws it
off (whether ceph_decode_need() or something else) is irrelevant -- we
are already toasted by then.  In the worst case no check could fire and
ceph_update_snap_trace() could interpret the bogus array data as
a valid ceph_mds_snap_realm with who knows what consequences...

Thanks,

                Ilya
