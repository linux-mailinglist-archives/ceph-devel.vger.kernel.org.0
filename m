Return-Path: <ceph-devel+bounces-57-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6D17E21A6
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 13:33:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 409ADB20DEF
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C5DC2EE;
	Mon,  6 Nov 2023 12:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mnSuKKuf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8EA15AC8
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 12:32:59 +0000 (UTC)
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BED7AD
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 04:32:57 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-586940ee5a5so2252488eaf.0
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 04:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699273976; x=1699878776; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5yL66pRd6foXwAVRWCbxnNbHQWEl8SjBz59oLXNSD48=;
        b=mnSuKKufb1y3mr2EG2O5w6god4WEw02d/hVp0lKdfEpEoCGrviO72uF5xXna6Xczc3
         yAcx8e75SIopIR64ky5WWoVVJ+YaUmtf55PX3Tt8rnvNRX89kEzJS/tSW7P/EBFcA1Ug
         RbOIVHX88pxiXkv1iwIgS9oDhOj53t3vcHHSnvnEEiJqGazAxM5C5t3Jm1MGRBkRjKUV
         bM2M4ya/b41iLaV4Tij5IK8E6rBxISnJwxkB4IvOrfPSEUixdA+lFEuOTwF5OH6vNSZ1
         o0vsEvSiRcBmDILIsdTr5YPtNULQ4JAo3Usia4/vWO0Jaj7npoPtRHwVIeM5cTirt18D
         7Nag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699273976; x=1699878776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5yL66pRd6foXwAVRWCbxnNbHQWEl8SjBz59oLXNSD48=;
        b=PWfvMPxP/JAk5T1DAkAyG8vd8WyD31T89Qq/bwo9O6n+elxTwjyzighM0oCi5L4vSX
         HnoW4qx0llH0sKk/NXLYJRadTzKQp+GuHy4kVDKAGemlR19+ZD4Vc3ODOEkiGo6VpRWh
         NDhrsq2xjSq/h4UOsTA5IfEF2OKOr8W0ZjkGot7dfEizyKYpf78OtmRE98NqtlINSlHQ
         YuEPkOX5keOoLdt1PZJWkt4zjbtPAVLJo/W1RG1Kbr210LQ3Xv5CRcHBNQ56HwWLUZzX
         KwT0RC8nbDU32gJLL3RDNqIQNnyMk6y0BpDLFVVeBhDrNTdo7hchgeQdMVowh+62merU
         JUhw==
X-Gm-Message-State: AOJu0YyOTOi5ndoeNLgvgmpkxtxK/cLDCU+GeQwYotgy0D7V/zdguibJ
	RRsJ31jOxugdddmngk7YorIxfwjmrTQQzwrTNnA=
X-Google-Smtp-Source: AGHT+IFv/maUFgEk9oUDHsjCextvu+qcar+IwRIpzd+Tqc/KSmGfEIzpcwOUYYj0BMTfvqy3w3tTCeT3X6W4R77aZ48=
X-Received: by 2002:a4a:a50c:0:b0:57b:7e41:9f11 with SMTP id
 v12-20020a4aa50c000000b0057b7e419f11mr25190593ook.2.1699273976523; Mon, 06
 Nov 2023 04:32:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231103033900.122990-1-xiubli@redhat.com> <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
 <e350e6e7-22a2-69de-258f-70c2050dbd50@redhat.com> <CAOi1vP9haOn0RujjiWU5TQ3F-ZEi8GKXYFV+xzTrX3V3saH46A@mail.gmail.com>
 <cee744a4-de97-0055-be94-1f928b06928e@redhat.com>
In-Reply-To: <cee744a4-de97-0055-be94-1f928b06928e@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 6 Nov 2023 13:32:44 +0100
Message-ID: <CAOi1vP-kUkUurOSS31_F9ND_X8BwxPp1uXo0EUkeuaP3ORK0Pg@mail.gmail.com>
Subject: Re: [PATCH] libceph: remove the max extents check for sparse read
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 1:15=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/6/23 19:38, Ilya Dryomov wrote:
> > On Mon, Nov 6, 2023 at 1:14=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wro=
te:
> >>
> >> On 11/3/23 18:07, Ilya Dryomov wrote:
> >>
> >> On Fri, Nov 3, 2023 at 4:41=E2=80=AFAM <xiubli@redhat.com> wrote:
> >>
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> There is no any limit for the extent array size and it's possible
> >> that when reading with a large size contents. Else the messager
> >> will fail by reseting the connection and keeps resending the inflight
> >> IOs.
> >>
> >> URL: https://tracker.ceph.com/issues/62081
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   net/ceph/osd_client.c | 12 ------------
> >>   1 file changed, 12 deletions(-)
> >>
> >> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> >> index 7af35106acaf..177a1d92c517 100644
> >> --- a/net/ceph/osd_client.c
> >> +++ b/net/ceph/osd_client.c
> >> @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct cep=
h_sparse_read *sr)
> >>   }
> >>   #endif
> >>
> >> -#define MAX_EXTENTS 4096
> >> -
> >>   static int osd_sparse_read(struct ceph_connection *con,
> >>                             struct ceph_msg_data_cursor *cursor,
> >>                             char **pbuf)
> >> @@ -5882,16 +5880,6 @@ static int osd_sparse_read(struct ceph_connecti=
on *con,
> >>
> >>                  if (count > 0) {
> >>                          if (!sr->sr_extent || count > sr->sr_ext_len)=
 {
> >> -                               /*
> >> -                                * Apply a hard cap to the number of e=
xtents.
> >> -                                * If we have more, assume something i=
s wrong.
> >> -                                */
> >> -                               if (count > MAX_EXTENTS) {
> >> -                                       dout("%s: OSD returned 0x%x ex=
tents in a single reply!\n",
> >> -                                            __func__, count);
> >> -                                       return -EREMOTEIO;
> >> -                               }
> >> -
> >>                                  /* no extent array provided, or too s=
hort */
> >>                                  kfree(sr->sr_extent);
> >>                                  sr->sr_extent =3D kmalloc_array(count=
,
> >> --
> >> 2.39.1
> >>
> >> Hi Xiubo,
> >>
> >> As noted in the tracker ticket, there are many "sanity" limits like
> >> that in the messenger and other parts of the kernel client.  First,
> >> let's change that dout to pr_warn_ratelimited so that it's immediately
> >> clear what is going on.
> >>
> >> Sounds good to me.
> >>
> >>   Then, if the limit actually gets hit, let's
> >> dig into why and see if it can be increased rather than just removed.
> >>
> >> The test result in https://tracker.ceph.com/issues/62081#note-16 is th=
at I just changed the 'len' to 5000 in ceph PR https://github.com/ceph/ceph=
/pull/54301 to emulate a random writes to a file and then tries to read wit=
h a large size:
> >>
> >> [ RUN      ] LibRadosIoPP.SparseReadExtentArrayOpPP
> >> extents array size : 4297
> >>
> >> For the 'extents array size' it could reach up to a very large number,=
 then what it should be ? Any idea ?
> > Hi Xiubo,
> >
> > I don't think it can be a very large number in practice.
> >
> > CephFS uses sparse reads only in the fscrypt case, right?
>
> Yeah, it is.
>
>
> >    With
> > fscrypt, sub-4K writes to the object store aren't possible, right?
>
> Yeah.
>
>
> > If the answer to both is yes, then the maximum number of extents
> > would be
> >
> >      64M (CEPH_MSG_MAX_DATA_LEN) / 4K =3D 16384
> >
> > even if the object store does tracking at byte granularity.
> So yeah, just for the fscrypt case if we set the max extent number to
> 16384 it should be fine. But the sparse read could also be enabled in
> non-fscrypt case.

Ah, I see that it's also exposed as a mount option.  If we expect
people to use it, then dropping MAX_EXTENTS altogether might be the
best approach after all -- it doesn't make sense to warn about
something that we don't really control.

How about printing the number of extents only if the allocation fails?
Something like:

    if (!sr->sr_extent) {
            pr_err("failed to allocate %u sparse read extents\n", count);
            return -ENOMEM;
    }

Thanks,

                Ilya

