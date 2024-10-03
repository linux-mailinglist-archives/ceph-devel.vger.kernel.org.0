Return-Path: <ceph-devel+bounces-1880-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA8198F4D8
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Oct 2024 19:09:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3525D2839DC
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Oct 2024 17:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D03801A7275;
	Thu,  3 Oct 2024 17:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="eQ0ANPeT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CED1A7248
	for <ceph-devel@vger.kernel.org>; Thu,  3 Oct 2024 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727975364; cv=none; b=nTwrRo0r65oBWUjD/I3KlAiLecuJZaSrKoVQHcRA029Rw0mF2WA9aRMHEWnM+SU3E8kWsbXbpzZQdWWQlbQ/GHeDZhNvYRXNsVBPmyB7nVo1l5Gb6j0Mr1HIHwmaqA3OMcj3MIoNVVUhGaGWonSVlEJyLErVik84CdKScIgZCoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727975364; c=relaxed/simple;
	bh=veZob2f6f+jF2aoHyYukXoVPX5HhWe0/4HygDAWChU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fACPns2rLnShOYb8V1eGO188v63phUUU1vVoghpxUpv70q5f3HCokJI0+H8nOyEr1HwyDhRDSkATflmQTnigDYJ/khP5KZS9bMVCy/YXHvT31BI3znlWQTm9I+98K1IFT2uSGVofD2OlnD/EH57QfEAME16guaYyZPdv8HecUPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=eQ0ANPeT; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6cb3cbc28deso10479446d6.3
        for <ceph-devel@vger.kernel.org>; Thu, 03 Oct 2024 10:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1727975362; x=1728580162; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lv6+V5DD1q+EbvJERytZupM7GavIklndcKQm84ak25U=;
        b=eQ0ANPeTYr8J7l35leuTWmevYYkn3K9uaDc2xiHwiHkiLe3SJ+5kibIXt7agq4PFDA
         JQeUfRsW08ZF3ba3BvlcmILg9PRosdgOwcoWZ610B9g29P9PX8fWgVVh9fqSJrT88H/P
         JqNHnzjsVMK8ESNdiSz1gSOgah2yixAcfEi5aXNaUFOBKEKyBJwaFtjtZCoSuHMHpLoY
         dzU2ZZ0ItUGWtzbdHoDRBlvR8C0YHbuhPLB81Is+wNq9pgJ08W/T017eQLZ7VGm3fG8z
         wuUzmqxV6scwPswbdeJUiaSFdUZYanVxkelJwG+RVL3CIF/01tKvZL0HKohFo0pr2syG
         wg4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727975362; x=1728580162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lv6+V5DD1q+EbvJERytZupM7GavIklndcKQm84ak25U=;
        b=aK7Ibg0zNbJU4oqWpcU7FTey3J4Rkh3m4sR7TS5P6pMUAgDE64FONlqmP9CsK8fINX
         w2YDzLniZyBjY98XvKXXdE36e8OEF9tgvF7fmTStHKJuMTIaB2E7vja/NOBGmg2r4K6C
         YyaoJzRwx0IJ6bKxRAwpUZRtyOdFHIyTsLOEY3OdPig3odYYjbqjK+t1yiJ0nql0PgPB
         BoFdHPi8pwgn8nRObSK5P0hLFUqfSMq9lHLr106+HApmrfLbLr8G/6JouM7xI5DXVpyh
         p448tQiUv+PkcWYtEb4BSjVapWb+ITQBWrv7b1luHSyhOuHFGD+e4eEyfd23d+24O5WA
         iQ/A==
X-Forwarded-Encrypted: i=1; AJvYcCUkhO7hGE8pVXO3Eese6P+l0f4Hv8I26QCv/FpdGOOmzk73jGPvRbLTKgksMHJ+4g7HQsvURO7nYTq+@vger.kernel.org
X-Gm-Message-State: AOJu0YyYVd3gLBQDYW4gc/mVc9YooxNac5vFBMRTUSqCtbckAW1npyp2
	kuvxMXvnIXhQ+AYqe3tGvpu5ec5iy4LZb7B7q2x43I4FzGsgyktddBO9ir6ZYSQ=
X-Google-Smtp-Source: AGHT+IEkPpCAXCAtA9gfAP3eyJpKVnJ4NiXCYXXWlVAcJ8PH9XCm1z/O2+YTyJX5Rf/ppniNPbZCyg==
X-Received: by 2002:a05:6214:5547:b0:6cb:3d8c:994a with SMTP id 6a1803df08f44-6cb81a955femr111164996d6.32.1727975361783;
        Thu, 03 Oct 2024 10:09:21 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cb937f478fsm8082636d6.121.2024.10.03.10.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 10:09:20 -0700 (PDT)
Date: Thu, 3 Oct 2024 13:09:19 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/6] btrfs: Switch from using the private_2 flag to
 owner_2
Message-ID: <20241003170919.GA1652670@perftesting>
References: <20241002040111.1023018-1-willy@infradead.org>
 <20241002040111.1023018-5-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002040111.1023018-5-willy@infradead.org>

On Wed, Oct 02, 2024 at 05:01:06AM +0100, Matthew Wilcox (Oracle) wrote:
> We are close to removing the private_2 flag, so switch btrfs to using
> owner_2 for its ordered flag.  This is mostly used by buffer head
> filesystems, so btrfs can use it because it doesn't use buffer heads.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef

