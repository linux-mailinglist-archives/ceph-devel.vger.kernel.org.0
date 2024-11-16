Return-Path: <ceph-devel+bounces-2154-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD889CFE44
	for <lists+ceph-devel@lfdr.de>; Sat, 16 Nov 2024 11:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 429211F22868
	for <lists+ceph-devel@lfdr.de>; Sat, 16 Nov 2024 10:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8D5199951;
	Sat, 16 Nov 2024 10:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lOr0EAjs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBCA194AC7
	for <ceph-devel@vger.kernel.org>; Sat, 16 Nov 2024 10:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731753630; cv=none; b=foxsW5maIOCEjGcoatW+AcW5dyPB+VNwfARvlqpmOpEOhWv6YlpX0aUONllcnbcuX1Jrb5z06eaBBEGC9cLaIrxxJgVlTSI+GJf0rnfHZBbqBQ0BbfBAKWG2/VY/2JKp7l8bcDpI7m/7xwvJtD1F77UmYYYN3Dc8MRh52GXFSlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731753630; c=relaxed/simple;
	bh=CZEDUO5w9mPwObdkuTZxxGHeinVe6UhoG9nSbMiKlmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNES0KAGy2YdL00mOlW3uny7pRPkossPWadbHTiUWehuLdJx333q0SBZHI4ET7TMtMMmmOZaVaSACrmnsrw19uvObnRzzb8BAoU57X9w9xlCtxBf7UyPMmXUQwhSX/T87ilZAF828F7LvbQhzZkyoUSSj3ZujfQU7dDcmXBfDfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lOr0EAjs; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4315e62afe0so23159555e9.1
        for <ceph-devel@vger.kernel.org>; Sat, 16 Nov 2024 02:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731753625; x=1732358425; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lSXFKM+ARjNBrckMO4jvpnEJoLVPjxN4kzAqYuwUUFc=;
        b=lOr0EAjsUTAs6wseY7V+KzGhBBAXZjQYXBU14sNlc1/O14eQQDJCcDwJbQy+ynWh8x
         qKYSwPKpD7hcY0em48Te+P6WgHqpu35ge0ehJQrBAIwLV1o/SBjRh/ZvjU5NZx3gT3tx
         Nb38XmMu1sSYZHZzBe1pPSA9zGPHDMFrcWnOK8hwpIeEoHXm17i4bbYBHX+fxtfFub7t
         AB/CIVUbhnAeSjtIwo5fLTeP/BEbRiasgOp5c9vKI4IN/cC9WOknw2cJK5jw1NCqW0qW
         50KI5IcyLcTqE0QRBK6ox2Z0l0vIcy/2tB1dBDoupmjqhuAI6LvRvVPAP/W62p1Msp52
         PaIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731753625; x=1732358425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSXFKM+ARjNBrckMO4jvpnEJoLVPjxN4kzAqYuwUUFc=;
        b=j5rHx/9HCLNnVNjWyudZ8cP58U4zp4U93PpXqIsfBv1J98BN4xoRsOKkOJyjNICujZ
         JcRRc7WXHICRVtXdKglFhH+0GHvDM9MU/IWhK1y5HrQecgKSvOi8CLFoWd1akQiWogBy
         1t3TaN29VoxtOSijh52ME2TSmLZFz5Dd1InZQA32TIqUkAzYtchg9NsMQC7xyZbo4O9x
         0cB/1wLt/lpnzmX1ZA7yW/pLD1g1mPQNTOtve8gBWKQuAkQnfIjIXzFIr+md1p1ebOhb
         D1nZwhdYAUKF8bYkezRJIarjLDbhLHwbHqRiy5Gm7zD490niM95M79aKRWqQAADda7Tu
         JUWg==
X-Forwarded-Encrypted: i=1; AJvYcCWvfrkijcrqSR4n2Tqhq/aBRua6QJkQc44vG57nDfYtjNQILWaqW5SID8QrikVwe3ieirs4nqOSimZ/@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn8dsu3M8q9oIwlFmlzcOQdJQwxH/ITPEs+zmRjKOF7M+EylwH
	uhBvlAFryh2hN+pinLpBBlsqKyOJw4GGYJzmbDtwVqyvQ7pIj7gfvwVASdUt16I=
X-Google-Smtp-Source: AGHT+IH8fBA+4s5F3P6X/kjn5LT5A4plOne9CKmDoZ8QUK+uLzjM3K0QAglApJbsapoZYtb9Ft2RHQ==
X-Received: by 2002:a05:600c:1d1c:b0:431:4e82:ffa6 with SMTP id 5b1f17b1804b1-432df78c5b5mr46184285e9.24.1731753625076;
        Sat, 16 Nov 2024 02:40:25 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da2800absm87243245e9.25.2024.11.16.02.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 02:40:24 -0800 (PST)
Date: Sat, 16 Nov 2024 13:40:20 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Easwar Hariharan <eahariha@linux.microsoft.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Russell King <linux@armlinux.org.uk>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ofir Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jeroen de Borst <jeroendb@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Shailend Chand <shailend@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
	Jens Axboe <axboe@kernel.dk>, Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Russell King <linux+etnaviv@armlinux.org.uk>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	Louis Peens <louis.peens@corigine.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-scsi@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	linux-mm@kvack.org, linux-bluetooth@vger.kernel.org,
	linux-staging@lists.linux.dev, linux-rpi-kernel@lists.infradead.org,
	ceph-devel@vger.kernel.org, live-patching@vger.kernel.org,
	linux-sound@vger.kernel.org, etnaviv@lists.freedesktop.org,
	oss-drivers@corigine.com, linuxppc-dev@lists.ozlabs.org,
	Anna-Maria Behnsen <anna-maria@linutronix.de>
Subject: Re: [PATCH v2 05/21] powerpc/papr_scm: Convert timeouts to
 secs_to_jiffies()
Message-ID: <e4872a15-ff3d-4619-9b03-c7f0b6230934@stanley.mountain>
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
 <20241115-converge-secs-to-jiffies-v2-5-911fb7595e79@linux.microsoft.com>
 <b6a059d8-7b23-455d-9ecd-eb3cdddd22a2@csgroup.eu>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a059d8-7b23-455d-9ecd-eb3cdddd22a2@csgroup.eu>

On Sat, Nov 16, 2024 at 11:06:55AM +0100, Christophe Leroy wrote:
> > diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
> > index 9e297f88adc5d97d4dc7b267b0bfebd58e5cf193..9e8086ec66e0f0e555ac27933854c06cfcf91a04 100644
> > --- a/arch/powerpc/platforms/pseries/papr_scm.c
> > +++ b/arch/powerpc/platforms/pseries/papr_scm.c
> > @@ -543,7 +543,7 @@ static int drc_pmem_query_health(struct papr_scm_priv *p)
> > 
> >          /* Jiffies offset for which the health data is assumed to be same */
> >          cache_timeout = p->lasthealth_jiffies +
> > -               msecs_to_jiffies(MIN_HEALTH_QUERY_INTERVAL * 1000);
> > +               secs_to_jiffies(MIN_HEALTH_QUERY_INTERVAL);
> 
> Wouldn't it now fit on a single line ?
> 

Some maintainers still prefer to put a line break at 80 characters.  It's kind
of a nightmare for an automated script like this to figure out everyone's
preferences.  In this particular file, there are some lines which go over 80
characters so sure.  Earlier in the patchset one of these introduced a line
break that wasn't there before so I think maybe Coccinelle is applying the 80
character line break rule?

There are sometimes where the 80 character rule really hurts readability, but
here it doesn't make any difference.

regards,
dan carpenter


