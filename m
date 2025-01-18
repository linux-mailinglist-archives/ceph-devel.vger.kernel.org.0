Return-Path: <ceph-devel+bounces-2513-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9BDDA15E9C
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Jan 2025 20:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F2FA3A7167
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Jan 2025 19:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C2554723;
	Sat, 18 Jan 2025 19:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CfO0mDbN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C170EBA38;
	Sat, 18 Jan 2025 19:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737228846; cv=none; b=onrE8Sg1ke/+SWeIX37ivxtdVCywJ3s5m2LGcJvVc1ULgRU/E7Pt5LTGPwMZ62BG1nQGDzg75Lv/I5LtcezP6KV0FIPosx6desDzbFWL7SB3KvSPG31OYasL4/IUMjNfArsPUzeR7BoQaUuHxs4UpTgOnBrRY2TdOOb/uXaNhJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737228846; c=relaxed/simple;
	bh=ZaUAwaVYsbXM0LTzZcZrlYTl2C/HIKWyop1x5o+NBJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bLpn6DHLcz+mCWoWFfj/ixp7nFkWEgkcwDK8FKLvKXnYwlcEp5OZx4OGnUnvTfiEBAJeJ56zVEL6n0XzyuQXbyBMvk5sMARr5kBlqDR4OSzsygnz6So/SWZHVZnFQLCQ7JqkS0pCd2ppjFvA9cjej5deB5oh9wNPiBN8VLRSBko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CfO0mDbN; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21636268e43so75247115ad.2;
        Sat, 18 Jan 2025 11:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737228844; x=1737833644; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbPhpOYQH+shnyo1pnYN81ZwvpDV6NB6IStJfEGDGZw=;
        b=CfO0mDbNexO0L/08AkfyWFXO9OuNgPk860s7FpvSGPUyrsGAfHR/z3aCUHEfr6hUym
         MMjkpKi1Dw/cmMgrHfhxLy0RELbFd0leDfUa/zLG48pqcIAV9fG9ggqDfBMqyxE6a1td
         ySYdU2zDyY8mYRiCBenMS74l4bqmqYUO52wae1JQJoUZ4xiUYqwAe+bj4J9Cu5XNStLY
         mL5E2kTBcNNr58XIiTaTBwK10SoDgMQOAveZ3euNFDT8PM/IA0jDRgWLFw90Ofyjfj0p
         6SwpbwWDP+dRZxatvnOK/mhWwlkr4gdxzOiewpvH7Xy6P/By/l53wDP5oGiE+DxoOJtH
         qORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737228844; x=1737833644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WbPhpOYQH+shnyo1pnYN81ZwvpDV6NB6IStJfEGDGZw=;
        b=pRJVfLEPosm7fNV67cfhziw1rgPREH144ES3qN4qnfnRUIjCUa9voA2/hXYjo7K3Hb
         fES+75c+31O2EboJ9rdXCFXUnj1/BUDuMhTODMn928G997yo1sPb/t25m3wrL6MmSXlH
         udc1TCwdeZGKaRSySe3gle37HpRcsugryKmxhGNSsj144UfmLHX7OvurO7GhFeHLZlJn
         iX0/sXS/l8SB0zJfE9Wp36dLpprw3uQup18yN9y0EMr1avhtfAOuK/iMuExy6S3HGoqI
         +a8qfyD8ooBdutR3XQSl00qFYX0zRmu9CrclPsFKdXlkSf4r091n6m18Kldwvsv0ONrI
         51qw==
X-Forwarded-Encrypted: i=1; AJvYcCU3vIaRs/dNPql2MoYtUHu6wpRgSnLEUdSmQ6tasRneAXdkaItH4DqqZl5GlAPJyPfJWdaYfbxMNAHY@vger.kernel.org, AJvYcCXsjPqDhCtY/HTaQdNKqKG1K9e1smEdLzsbayJ4K4Dj4V6S/7LUMYoZq983qz+qASbCM1wB0tabAwyKOcoN@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0bD44bmIb4SDCAf/FrAMzD5G0QvwmdS/cRtwY3evXGzUfd0R0
	4qFx6SAs8HzWgntodZSIqIBaTrXu2CyubiAMAEedm/1npLkM6hhcI13iN+wy/yUzPFUe1kqAQcs
	KiDz0x5hqB8A4jUPV7QHch/qd6RI=
X-Gm-Gg: ASbGncu3oL6j+uaBNPZsUwRaWC//Jlmfhi8201Te/mRsiKM4USNDGThiqjc6PfmL3bW
	kn9RIe+O7wX/MSPYMWXnIMZZ6H4f1dWm2GuMSlWnG2/RI4/G9V+k=
X-Google-Smtp-Source: AGHT+IEzLqy4YDkOXZcXTOrO4rFeYO5uA6exruMrrqLI37pxebVsGSTw3BtAvXWt8ryA8CbsgmQZrCREt7W5xn6AE1M=
X-Received: by 2002:a17:902:e810:b0:215:a412:4f12 with SMTP id
 d9443c01a7336-21c355bfa7cmr105328695ad.33.1737228843790; Sat, 18 Jan 2025
 11:34:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOi1vP8vNjDpyqT8wd0AuEWfvMjn0r5tML=pMNbWYb=kATAaOg@mail.gmail.com>
 <20250118135243.3560118-1-buaajxlj@163.com>
In-Reply-To: <20250118135243.3560118-1-buaajxlj@163.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Sat, 18 Jan 2025 20:33:52 +0100
X-Gm-Features: AbW1kvYlWc_XAQw3C7ZX_tpS6S3QVkMuR3kVBUEXr0L2Dts2EGe3oenQQ3NwKDU
Message-ID: <CAOi1vP_VvZCYzDnuhAzaJ51DeFhsO9ZVvbEL-Rc7wPPWnJyA1g@mail.gmail.com>
Subject: Re: [PATCH] ceph: streamline request head structures in MDS client
To: Liang Jie <buaajxlj@163.com>
Cc: Slava.Dubeyko@ibm.com, ceph-devel@vger.kernel.org, fanggeng@lixiang.com, 
	liangjie@lixiang.com, linux-kernel@vger.kernel.org, xiubli@redhat.com, 
	yangchen11@lixiang.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 18, 2025 at 2:53=E2=80=AFPM Liang Jie <buaajxlj@163.com> wrote:
>
> On Wed, 15 Jan 2025 21:15:11 +0100, Ilya Dryomov <idryomov@gmail.com> wro=
te:
> > On Fri, Jan 10, 2025 at 8:25=3DE2=3D80=3DAFPM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Fri, 2025-01-10 at 18:05 +0800, Liang Jie wrote:
> > > > From: Liang Jie <liangjie@lixiang.com>
> > > >
> > > > The existence of the ceph_mds_request_head_old structure in the MDS
> > > > client
> > > > code is no longer required due to improvements in handling differen=
t
> > > > MDS
> > > > request header versions. This patch removes the now redundant
> > > > ceph_mds_request_head_old structure and replaces its usage with the
> > > > flexible and extensible ceph_mds_request_head structure.
> > > >
> > > > Changes include:
> > > > - Modification of find_legacy_request_head to directly cast the
> > > > pointer to
> > > >   ceph_mds_request_head_legacy without going through the old
> > > > structure.
> > > > - Update sizeof calculations in create_request_message to use
> > > > offsetofend
> > > >   for consistency and future-proofing, rather than referencing the
> > > > old
> > > >   structure.
> > > > - Use of the structured ceph_mds_request_head directly instead of t=
he
> > > > old
> > > >   one.
> > > >
> > > > Additionally, this consolidation normalizes the handling of
> > > > request_head_version v1 to align with versions v2 and v3, leading t=
o
> > > > a
> > > > more consistent and maintainable codebase.
> > > >
> > > > These changes simplify the codebase and reduce potential confusion
> > > > stemming
> > > > from the existence of an obsolete structure.
> > > >
> > > > Signed-off-by: Liang Jie <liangjie@lixiang.com>
> > > > ---
> > > >  fs/ceph/mds_client.c         | 16 ++++++++--------
> > > >  include/linux/ceph/ceph_fs.h | 14 --------------
> > > >  2 files changed, 8 insertions(+), 22 deletions(-)
> > > >
> > >
> > > Looks good to me. Nice cleanup.
> > >
> > > Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> >
> > Applied.
> >
> > Thanks,
> >
> >                 Ilya
>
> Hi Ilya,
>
> I have recently received a warning from the kernel test robot about an in=
dentation
> issue adjacent to the changes made in my this patch.
>
> The warning is as follows:
> (link: https://lore.kernel.org/oe-kbuild-all/202501172005.IoKVy2Op-lkp@in=
tel.com/)
>
> > New smatch warnings:
> > fs/ceph/mds_client.c:3298 __prepare_send_request() warn: inconsistent i=
ndenting
> >
> > vim +3298 fs/ceph/mds_client.c
> >
> > 2f2dc053404feb Sage Weil      2009-10-06  3272
> > ...
> > ce0d5bd3a6c176 Xiubo Li       2023-07-25  3295        if (req->r_attemp=
ts) {
> > 164b631927701b Liang Jie      2025-01-10  3296                old_max_r=
etry =3D sizeof_field(struct ceph_mds_request_head,
> > ce0d5bd3a6c176 Xiubo Li       2023-07-25  3297                         =
                   num_retry);
> > ce0d5bd3a6c176 Xiubo Li       2023-07-25 @3298               old_max_re=
try =3D 1 << (old_max_retry * BITS_PER_BYTE);
> > ce0d5bd3a6c176 Xiubo Li       2023-07-25  3299               if ((old_v=
ersion && req->r_attempts >=3D old_max_retry) ||
> > ce0d5bd3a6c176 Xiubo Li       2023-07-25  3300                   ((uint=
32_t)req->r_attempts >=3D U32_MAX)) {
> > 38d46409c4639a Xiubo Li       2023-06-12  3301                        p=
r_warn_ratelimited_client(cl, "request tid %llu seq overflow\n",
> > 38d46409c4639a Xiubo Li       2023-06-12  3302                         =
                          req->r_tid);
> > 546a5d6122faae Xiubo Li       2022-03-30  3303                        r=
eturn -EMULTIHOP;
> > 546a5d6122faae Xiubo Li       2022-03-30  3304               }
> > ce0d5bd3a6c176 Xiubo Li       2023-07-25  3305        }
>
> The warning indicates suspect code indent on line 3298, existing before m=
y
> proposed changes were made. After investigating the issue, it has become =
clear
> that the warning stems from a pre-existing code block that uses 15 spaces=
 for
> indentation instead of conforming to the standard 16-space (two tabs) ind=
entation.
>
> I am writing to seek your advice on how best to proceed. Would you recomm=
end that
> I adjust the indentation within the scope of my current patch, or would i=
t be more
> appropriate to address this as a separate style fix, given that the inden=
tation
> issue is not directly introduced by my changes?

Hi Liang,

I noticed the indentation mismatch myself and, when applying, edited
your patch to be consistent with the pre-existing block (it's actually
a tab + 7 spaces, no idea why):

https://github.com/ceph/ceph-client/commit/929fba81687e4ba6ed9af18fc1f34e76=
ac90772a

It looks like this warning was generated based on the patch as posted,
not as applied, so it can be ignored.

>
> I am happy to make the necessary adjustments to ensure the code base adhe=
res to the
> kernel's coding standards. However, I also want to respect the best pract=
ices of
> contributing to the project and maintain the clarity and focus of my patc=
h.
>
> Kindly advise on the preferred way forward.
>
> Thank you for your time and guidance.

Thank you for being thorough!

                Ilya

