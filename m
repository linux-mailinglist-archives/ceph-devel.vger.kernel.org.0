Return-Path: <ceph-devel+bounces-49-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB837E203D
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05EA01C20B6E
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 11:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94029199B3;
	Mon,  6 Nov 2023 11:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bX0OiLuH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13451A58A
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 11:42:30 +0000 (UTC)
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263BF123
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 03:42:29 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-587b1231dbeso599723eaf.3
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 03:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699270948; x=1699875748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=McDMJ9f3wA9PZoy0FjQW8xG3Hor3yYa8NoqqcCZOVKc=;
        b=bX0OiLuHqEG78XeE/tJuDWnBKnbyhninUN9wxyh/O5y1rBdtoC7DhQXlHi0w2AoaWk
         ZHGQIih/cw+oZ/XdmTbNPG/Rtopi45ZAM3mjEmDcSwrvU7w/UuQSAP5NBi+kAdXqe39L
         9LQ837OACtvq8IQKFk+VwL0Jco9Oj1zqzJmYbxJnj0KprhZr/koq0tq8rA/RcgQk7Btn
         7keDOiWoyetyACXBLH4+DIQrqg7i8mJkZ3LixMTCVt+K/vBcTe7PtVDFMrfhm/VkNBZb
         4KdDBoHkSKoEsPHDbOKPmUDOHtUO4wP0s0hFNC4oKPX7o88unUcOKEd9CYFBC/JgGkcK
         5stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699270948; x=1699875748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=McDMJ9f3wA9PZoy0FjQW8xG3Hor3yYa8NoqqcCZOVKc=;
        b=PWn71pFiy2K8YQYLAPZX/DJBymrbQFC1Zn5rnYjcAYs3GRFfHUGXj4o/+aOlCw9WtJ
         1kWWqObVURHMNAjuYoEVgjciKWW9fpID5Ad91ysy3n1De0koykhw9t7sDFMnEek63fc7
         MS+5LsW8uKnGASEs+v8AgpYGCMAWwwKXxTfFTNHtyuUAQGb9Wkrc0pK/zNvEdzxJQC/G
         fbUiEy3PdQ0HtRLr9dKkKBk5G9TRYhWoPRkenY7vr3mskjBTduJt2fp3TUdta24QMKzt
         PLfI0y6kbyS464UTQ1hklMI+BR786VxpaoYimCQq00ntz3Za0Fq7Q0n/tJgJIW1gbMSd
         f5xw==
X-Gm-Message-State: AOJu0YxD8HROh++0vBrREV1lnzN1MqNonK4CcfPp3KRs6xKYgP1dawKQ
	pwym5OEbKgIE0aFBCDabHoRf1o6pOfVIT7fTDUs=
X-Google-Smtp-Source: AGHT+IGQM5MF0jcbOFLwxMxsfvsHzgFiD3iFpwSVVg4dc8V1KnZ4MleIqVyx0X1tSLXQ5/3EC3G9hPedhZzJ5NWFSpM=
X-Received: by 2002:a4a:bb89:0:b0:581:d922:e7f3 with SMTP id
 h9-20020a4abb89000000b00581d922e7f3mr25187253oop.9.1699270948433; Mon, 06 Nov
 2023 03:42:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231103033900.122990-1-xiubli@redhat.com> <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
 <23b5dc4e0607a033714e50c3326d587fd0cf99bf.camel@kernel.org> <1cded211-047b-ae79-fcf8-0838c1f8a21c@redhat.com>
In-Reply-To: <1cded211-047b-ae79-fcf8-0838c1f8a21c@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 6 Nov 2023 12:42:16 +0100
Message-ID: <CAOi1vP8x0-o3+wqi6oTBAY_v7-SnvNoC48AcCAJP8BOAUb+sLg@mail.gmail.com>
Subject: Re: [PATCH] libceph: remove the max extents check for sparse read
To: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 6, 2023 at 7:43=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/3/23 18:14, Jeff Layton wrote:
> > On Fri, 2023-11-03 at 11:07 +0100, Ilya Dryomov wrote:
> >> On Fri, Nov 3, 2023 at 4:41=E2=80=AFAM <xiubli@redhat.com> wrote:
> >>> From: Xiubo Li <xiubli@redhat.com>
> >>>
> >>> There is no any limit for the extent array size and it's possible
> >>> that when reading with a large size contents. Else the messager
> >>> will fail by reseting the connection and keeps resending the inflight
> >>> IOs.
> >>>
> >>> URL: https://tracker.ceph.com/issues/62081
> >>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>> ---
> >>>   net/ceph/osd_client.c | 12 ------------
> >>>   1 file changed, 12 deletions(-)
> >>>
> >>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> >>> index 7af35106acaf..177a1d92c517 100644
> >>> --- a/net/ceph/osd_client.c
> >>> +++ b/net/ceph/osd_client.c
> >>> @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ce=
ph_sparse_read *sr)
> >>>   }
> >>>   #endif
> >>>
> >>> -#define MAX_EXTENTS 4096
> >>> -
> >>>   static int osd_sparse_read(struct ceph_connection *con,
> >>>                             struct ceph_msg_data_cursor *cursor,
> >>>                             char **pbuf)
> >>> @@ -5882,16 +5880,6 @@ static int osd_sparse_read(struct ceph_connect=
ion *con,
> >>>
> >>>                  if (count > 0) {
> >>>                          if (!sr->sr_extent || count > sr->sr_ext_len=
) {
> >>> -                               /*
> >>> -                                * Apply a hard cap to the number of =
extents.
> >>> -                                * If we have more, assume something =
is wrong.
> >>> -                                */
> >>> -                               if (count > MAX_EXTENTS) {
> >>> -                                       dout("%s: OSD returned 0x%x e=
xtents in a single reply!\n",
> >>> -                                            __func__, count);
> >>> -                                       return -EREMOTEIO;
> >>> -                               }
> >>> -
> >>>                                  /* no extent array provided, or too =
short */
> >>>                                  kfree(sr->sr_extent);
> >>>                                  sr->sr_extent =3D kmalloc_array(coun=
t,
> >>> --
> >>> 2.39.1
> >>>
> >> Hi Xiubo,
> >>
> >> As noted in the tracker ticket, there are many "sanity" limits like
> >> that in the messenger and other parts of the kernel client.  First,
> >> let's change that dout to pr_warn_ratelimited so that it's immediately
> >> clear what is going on.  Then, if the limit actually gets hit, let's
> >> dig into why and see if it can be increased rather than just removed.
> >>
> > Yeah, agreed. I think when I wrote this, I couldn't figure out if there
> > was an actual hard cap on the number of extents, so I figured 4k ought
> > to be enough for anybody. Clearly that was wrong though.
> >
> > I'd still favor raising the cap instead eliminating it altogether. Is
> > there a hard cap on the number of extents that the OSD will send in a
> > single reply? That's really what this limit should be.
>
> I went through the messager code again carefully, I found that even in
> case when the errno is '-ENOMEM' for a request the messager will trigger
> the connection fault, which will reconnect the connection and retry all
> the osd requests. This looks incorrect.

In theory, ENOMEM can be transient.  If memory is too fragmented (e.g.
kmalloc is used and there is no physically contiguous chunk of required
size available), it makes sense to retry the allocation after some time
passes.

>
> IMO only in case when the errno is any of '-EBADMSG' or '-EREMOTEIO',
> etc should we retry the osd requests. And for the errors that caused by
> the client side we should fail the osd requests instead.

The messenger never fails higher level requests, no matter what the
error is.  Whether it's a good idea is debatable (personally I'm not
a fan), but this is how it behaves in userspace, so there isn't much
implementation freedom here.

Thanks,

                Ilya

