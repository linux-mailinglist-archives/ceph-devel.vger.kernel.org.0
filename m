Return-Path: <ceph-devel+bounces-3211-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A4DAE7FBD
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 12:41:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FA4B3B2EF6
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 10:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A944C29B233;
	Wed, 25 Jun 2025 10:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SaB+qOtM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABF725BEF6
	for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 10:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750848073; cv=none; b=LYikdb4rv6UZZQC0jOc4AT15WiY8+T1jcP286SN6w0YiENiS8q+8HOGEYGvEnzbeAP4Cf8OrNID/TbXjPwBXeu4YHuWl2/7qyPnV4+/C0SqrJY41ME37XPcLY4rFg9H4MvQisVeSJyuht7I+unKWVlFIRZ4mN+E/Nn2cipd3ucc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750848073; c=relaxed/simple;
	bh=AIVz62DuTVWDixko6X2LPuwXhOwmi4DqwR/TSjDPY3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RMWPac1MKpSqDupNVnGevORgY/KeB2WRG5gSw98Z5NLb8aNnVdjzBMcHr0yasgXlEi7pN4TMaJDFtPeb5qnPLAez6pV1ycTCoZChSN/kdk+9hdH6SMZF8T+FvwuHoZmB7q/37dEit3v/ZeHbZ5dLoJ7phEfzqbTsQXUMWwI+l5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SaB+qOtM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750848071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aKr+DQBtFyizAsw1988hOJcgz/t/EULmqa75FsXdoB8=;
	b=SaB+qOtMuuvj0kM2pUKYH2skTBGcQ826VIyaRBSFOWcRSLTBSOnWIAfbYzF8ipoPrDoon3
	orODjmr/AJRtjpY1nQvQQc5f/UJqgwN6UqEuFSIDrmhtA2oq7C5BH7el0W8XExV7v/+lZQ
	g22EsoZ8HmQMbmSEukodNtrn8TTIC3E=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-Bx-kpXihNtql653AygOCsQ-1; Wed, 25 Jun 2025 06:41:09 -0400
X-MC-Unique: Bx-kpXihNtql653AygOCsQ-1
X-Mimecast-MFC-AGG-ID: Bx-kpXihNtql653AygOCsQ_1750848069
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-531566c838cso363952e0c.2
        for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 03:41:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750848069; x=1751452869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aKr+DQBtFyizAsw1988hOJcgz/t/EULmqa75FsXdoB8=;
        b=oLFrFvhqSJWL0Y4dL/Bu38TFhV61O/J3uwvI85Tcca0l/P8vhgcgPSdm8TrDIGKgt4
         wNnWywNCm6nCmK58+wM3DSi/VHGGRgwnS9nK4FzkYo+XtAWstBTsuQdglnU6zBMDyr+G
         493R7Hk3/Bp5oJqF3we0ychBpwfvmxFsy0YSFp0+nli1PdqTbc7NNW6tkGZssXYCjEKU
         u+HdOG87yr2eQJsUSwGRjlNSdDYkuyjUWfrOkuuWDG4PHSN2QdcqTKhysciCr4q67C5/
         GPLWVjbaBvzPDdVL9+4pRHoQammugh/JYp8XNT+/PnfVMMc+Xw2A5v6Yf+VrIh3vZFpR
         dJnA==
X-Forwarded-Encrypted: i=1; AJvYcCXGFlOtDzIP6z7CqaSDeopSBgRoSRyc0LFtZreMhMzzjGQd43Q3OCNF6xq9zEET+XvBRWwx75vOYxg2@vger.kernel.org
X-Gm-Message-State: AOJu0YwBolRtwQgTRZf4XPR5kFzReRbx4kKWBkEuyITA4GF6YuAARu6l
	QiwuEH6mBb3xsdd71+EF0nKX3lOknP3kfvVTDaZIngqw5cU8P227bQU2oIJuKA+SfrMP0fvc5YA
	p0Ve7NiUCbA+3h94h1JQRrjQvrSYZ3Qd4AnQIev1B4r2yMEbKE2xxpJMsiA0UtAbrz1KT9EgoLH
	D7yMGws60Fh1XP2iPLFUttbpfxJb52RUxFtoc2Wg==
X-Gm-Gg: ASbGnctQDH+JqF6QhzNbH+BiFMQCi2BAe2Bg7oqJFzyEV12ENnzt08ghnHe7sj3jm8t
	XSzbbKo0Assi7b5SasvbyjUTD5HVz86zBDwrcYVcSqehopg5WUN+dn+BMziDUI2r8v/8paGZ3Sf
	qN
X-Received: by 2002:a05:6122:1314:b0:531:312c:a715 with SMTP id 71dfb90a1353d-532ef36d88bmr1312854e0c.2.1750848069184;
        Wed, 25 Jun 2025 03:41:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKSrlq1vbTvn3Juc6W5KhrcexBGZURwwZbo6o+xxVCTx25vGfBDJ/xWAUugd4sgcE788El/lgs5X0WkOKHVaQ=
X-Received: by 2002:a05:6122:1314:b0:531:312c:a715 with SMTP id
 71dfb90a1353d-532ef36d88bmr1312845e0c.2.1750848068518; Wed, 25 Jun 2025
 03:41:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612143443.2848197-1-willy@infradead.org> <20250612143443.2848197-2-willy@infradead.org>
In-Reply-To: <20250612143443.2848197-2-willy@infradead.org>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 25 Jun 2025 13:40:57 +0300
X-Gm-Features: Ac12FXyp1o1FcravfvrXONE97kHRXN5UStXCBn6AB_JACNodeZdJ-QuOTaMpRIc
Message-ID: <CAO8a2ShgtKP-_V=YZ1NUvSUeoS8_mX7de20nP=P=RfdH5n=XTA@mail.gmail.com>
Subject: Re: [PATCH 1/5] bio: Use memzero_page() in bio_truncate()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good cleanup.

Reviewed-by: Alex Markuze amarkuze@redhat.com

On Thu, Jun 12, 2025 at 5:35=E2=80=AFPM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> memzero_page() is the new name for zero_user().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  block/bio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 3c0a558c90f5..ce16c34ec6de 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -653,13 +653,13 @@ static void bio_truncate(struct bio *bio, unsigned =
new_size)
>
>         bio_for_each_segment(bv, bio, iter) {
>                 if (done + bv.bv_len > new_size) {
> -                       unsigned offset;
> +                       size_t offset;
>
>                         if (!truncated)
>                                 offset =3D new_size - done;
>                         else
>                                 offset =3D 0;
> -                       zero_user(bv.bv_page, bv.bv_offset + offset,
> +                       memzero_page(bv.bv_page, bv.bv_offset + offset,
>                                   bv.bv_len - offset);
>                         truncated =3D true;
>                 }
> --
> 2.47.2
>
>


