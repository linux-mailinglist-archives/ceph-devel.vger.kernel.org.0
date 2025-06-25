Return-Path: <ceph-devel+bounces-3213-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2D2AE7FCA
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 12:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A421216C093
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 10:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0BAA2BEC39;
	Wed, 25 Jun 2025 10:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8beGsY4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09872BD01E
	for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 10:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750848101; cv=none; b=XAOM8OmyWFc71YOjZPKoq/IRfWqpiKEq+hFLlLKu5OVYiv28wBk4lYeC/N4wS1Ke0u6DcMq+7qSX4k3hhMeM8qsjdO1t0FiFIhSj0XjXJQ6rvI/r7+28yofPsb3lQSn3ipjVDfzTKIJpCEGp+BQiYk1h7w5eJ7Gr7CGTkNmnxdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750848101; c=relaxed/simple;
	bh=lOruoolLdTMrM1hsoH9Ovds3ZTDlEFaydFSeZp1B4V8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ln7A0SbqV39tK++icZEfNZj9jlgEkCGIQwhFAU1HYMoGgcMzGJOvVNtJozTC3DH+mxUU5c2NhYSUdhIANeQvkYAilxp7/1KwLad/+5NU7hDeRy6x4FMq7w1oukHT0QXIubMFETGdb8G4dsnBAR41Zpe6Q8oAWZV9YEBntUDmlnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i8beGsY4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750848097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AXzJ6BG9oFnQy0s13phUi78sKWJpBfX2ctrsD+v2g/I=;
	b=i8beGsY4hPas5s45QT7zLBLbuMSBKXD3aOrqDkhr51Gqr0eLQptrhvh7kESI1JxN5GklJx
	ltWqoEtdI+DrWqVehwJseZ2wgC/sgRpjey6Sk5sGBfLm2vxSLe3HT0PH5VJupOA8pBswQ1
	Ubf9yWSIqhhxBoKQxPVcPji7+Qxl2IM=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-OFJbWEnbP2CFVBYKZ7JveQ-1; Wed, 25 Jun 2025 06:41:36 -0400
X-MC-Unique: OFJbWEnbP2CFVBYKZ7JveQ-1
X-Mimecast-MFC-AGG-ID: OFJbWEnbP2CFVBYKZ7JveQ_1750848096
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-4e1d86bf3dfso1431247137.2
        for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 03:41:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750848096; x=1751452896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AXzJ6BG9oFnQy0s13phUi78sKWJpBfX2ctrsD+v2g/I=;
        b=af3GjtU3GK4vuFrWUMAnqwPlD80AtR0Id+17brmb/jgMxon9MzlFwV9F4ABJRkFiQU
         y+io6Xw/t5ELOA+InFuN0lF7r39vgmCvDBMgV6AxkCvtQ3pqrKyXwol5lQIKUyA2cLJm
         evG7herAnvIo1FaB7hc/IkJ6T4xoLVo36IphTxOmUPZnqH0Djc11w574mCDY+o2m+S++
         mlRjklZRnoGIez2qj62ayzKS/zZHERBnR6Jg0bGmBQJjHc1OrofDZ9EsgyictiQ5Ym1M
         i4l/fFLTe6qK2aXsCP/N1GgLozW5TfUfRdn0GKCpuVdNstLfMpWkSAZ2o7cAAcXpwLnZ
         h8Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUIQweEh90NGOdLeFVK/ES571NAYqxtxYPkPnOJp/n8U2G3kz++D/2la+ylZTuwHWmOTm2KD6b/CMG7@vger.kernel.org
X-Gm-Message-State: AOJu0YylU4Lb+NdGVg+1TVHmOm8uyfiuEPk3QT9oXIe8EI0x4MDHJel5
	MbfVGuk86v4WM59j4H4P+U5jU5cid5+xpiTKkezL75yn0db+OKHy+KHa4oVz2NkEjCPgx5XT8b9
	lRNyEHoQCssn3n3dq/E6EpTFl4AqS9Wj+L8EpU7LwWIIawuwj06zFcq/dSnRbZaImKO9h8ethGX
	AtU0QcpWBs1GOH359T4vof/dHJFhr3IpQrploA5g==
X-Gm-Gg: ASbGncv0MUnz6BqJsYsLipADxTr5MQYgIjNnJumlXTZzVEpTAXZgh+nU6xIMYLSEj5t
	hvdY573dJjtBdmp7RQ0CRPTfS9xIqpXw1PFnGQDW7KXnSmfzzd6j0GD88zHN/wIegksAh2TslhI
	/T
X-Received: by 2002:a05:6102:e0b:b0:4e5:a316:6ee6 with SMTP id ada2fe7eead31-4ecc769c5d5mr977808137.18.1750848096261;
        Wed, 25 Jun 2025 03:41:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3rRMb8Kv0RHeqhtdNcN4p/j7yM7WdX52zFHAZihqFaG1oWPDvEzBZJHq9Wbj3VxPRs3mj3K9chbZ2rnwyba8=
X-Received: by 2002:a05:6102:e0b:b0:4e5:a316:6ee6 with SMTP id
 ada2fe7eead31-4ecc769c5d5mr977794137.18.1750848095914; Wed, 25 Jun 2025
 03:41:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612143443.2848197-1-willy@infradead.org> <20250612143443.2848197-6-willy@infradead.org>
In-Reply-To: <20250612143443.2848197-6-willy@infradead.org>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 25 Jun 2025 13:41:25 +0300
X-Gm-Features: Ac12FXwFWhOETzcvDHbBzNovjF_5IML_YC5DRczUGY04YVAWJAwP94hRxUpsl0Q
Message-ID: <CAO8a2Sg5Q7iYTSjR2iD3R+EXHe5O735zp4V=Ur17q8AgkJFCcA@mail.gmail.com>
Subject: Re: [PATCH 5/5] mm: Remove zero_user()
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
> All users have now been converted to either memzero_page() or
> folio_zero_range().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/highmem.h | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index e48d7f27b0b9..a30526cc53a7 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -292,12 +292,6 @@ static inline void zero_user_segment(struct page *pa=
ge,
>         zero_user_segments(page, start, end, 0, 0);
>  }
>
> -static inline void zero_user(struct page *page,
> -       unsigned start, unsigned size)
> -{
> -       zero_user_segments(page, start, start + size, 0, 0);
> -}
> -
>  #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
>
>  static inline void copy_user_highpage(struct page *to, struct page *from=
,
> --
> 2.47.2
>
>


