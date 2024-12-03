Return-Path: <ceph-devel+bounces-2240-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 10D169E2CD7
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 21:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D679CB31BC0
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 18:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250221FC7EF;
	Tue,  3 Dec 2024 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rBVOdYsW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283DA1FBEA7
	for <ceph-devel@vger.kernel.org>; Tue,  3 Dec 2024 18:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733250584; cv=none; b=YxnE+pdr8QeaH9BlztJoDHdhQMbDODCCYHyuaLTVLgfjiEwxTFaaMRGB1zmIls159pvUUvzr0RDSlScwt4+ea+IgQghEudLLk51nyfUD2XgMNdj+aH5p0QsnLgcedRntePrBfoXIODtKvHCiYFML/qy6nHkw7ftH9tR5B0svM2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733250584; c=relaxed/simple;
	bh=agLgcQLieVyrvcqGbkgbP0D1qGeS9ONSZ17Cqy+yOcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9dt157iUi2xH5jwJNJnfLRcgsVzRSw4nDyud4wy1NfkHv7300BN+lVTBHKv9j0XPCM10eo71UCtbbuu88h13OO/QkU3dzJo5ZRbN67kVbhomWuhyB0dPetNY0GOD/KqfkEg4V2CfJc9Rw9NpDQVHEOpf/tAbStIOHJi3tWGWSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rBVOdYsW; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4349fd77b33so48365395e9.2
        for <ceph-devel@vger.kernel.org>; Tue, 03 Dec 2024 10:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733250580; x=1733855380; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qf0AnOkCKBwB1WK89tSCWB+hsIxd8TuIxna0rUXN2J0=;
        b=rBVOdYsWQRn5bGoPdfJ1D/ggK5Y00KP8FB+0QC7E7dPfCtouBrU2tcf8PZrxI25eO5
         OmyRQslUOPNftR26ylk9cwOtMiGWJTUwE5u+VjzwQvnoqdH6FVU6CeZlsyMtmJO3YXOI
         +y7P5yMke3vHIVpaHwkVO2zrjd6Fm8v9xMV6GI5h07bu/eTFXX4Ksl9ycF7frLWQtf/n
         4gnLcNOmSD7+EZPYjlkpXbvPEaGKEEbzvDncMMtOyutjg/HQl7+pPB2H1x4pjnLB5vre
         1MgRoqAPh1FLy4ut3I1kod83RLsbs5ZUwNBJBOrpXE5HDk1+Oyz9o2RKbh6fFNLcBrAn
         Sm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733250580; x=1733855380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qf0AnOkCKBwB1WK89tSCWB+hsIxd8TuIxna0rUXN2J0=;
        b=dVtYbY0KjRzGUZpGcZF8EeBKnc3C6i4XanvTfllMWyQqUocDHquYgPapw9ToMhj/c9
         O/033caCTvsmAXfJJO5HBZPCzdUVlyUL7Dn0X7cM9qhfnzVX5OQKPAJkC5fIGzZrk8//
         y9ucsJge6+17WjShKN4nnCJLcHOZ54hGskTN4Me3+tAjstNJqZgcCf28OBqv2DU3MQPR
         An7+vtGJfYrCGrRmbS2sMnTDkW7PGuj01YabpoKZ0S5o7J/onbkooSjkVdV5JfLVLAKJ
         ypNGmPOlM4E8i9Vje02bcwULaUez83ILqXrvY3zcwNiMZ+BsI2NQzKmtkUrvZ3MMgPzS
         6/Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUm+cseDmzRZLqC+wQs3lM4Q51rIlwMgf9A2LRT35pT5uL5kgNChdTOyMRYAAS5s340JXj/bSzF8fyf@vger.kernel.org
X-Gm-Message-State: AOJu0YzoJlRCaL9f+luvzX+WpssKNJGBypFWeFV+SAwPLOhoNNVAeQFC
	JMLkLmJrOhyaJjTBiCPa8Nyj/7XUHyTkiv27vw0tVxqilZRkvM+jKCrO2a6xS/A=
X-Gm-Gg: ASbGncuc5tIiPEqMgBpvfFn4gxebFx/UIYm1A8QdG4hu55z4FHS9RzPh8nFIQAR7rWA
	rzLQGKwAm71M4fQmUELXyxc6nkWihM6CFnyUtSUnLNgYd8Y8BLC9O90PK8mCMt/uXx9+aOfBq/Y
	13pGeo1s5V270gMqssEKeJZC5VTuej5dNWg2HlvkstLuyODMFV3CEqJOe19ICFlHLXEfZ+v4xLE
	gXvnlTeGMiuJB2p6odPAH0eRePSLaxGiyGRGIOsEYCkBsZTIefnY+c=
X-Google-Smtp-Source: AGHT+IF1kLG7zVHMpyS9c7iFXFIZf0+r0yyyReDQk236Sg7h7ThKmIgaUhHFEEl9EsnFiqwlrEeuDQ==
X-Received: by 2002:a7b:cc85:0:b0:434:a59c:43c6 with SMTP id 5b1f17b1804b1-434d0a03d75mr29305785e9.26.1733250580341;
        Tue, 03 Dec 2024 10:29:40 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385e9c075e8sm9609115f8f.7.2024.12.03.10.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 10:29:39 -0800 (PST)
Date: Tue, 3 Dec 2024 21:29:35 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alex Elder <elder@riscstar.com>
Cc: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [bug report] ceph: decode interval_sets for delegated inos
Message-ID: <a7f2d7f9-014b-4535-a0d1-74c351d13eca@stanley.mountain>
References: <e660f348-5a0e-486d-8bae-e6c229f0e047@stanley.mountain>
 <d75b6bb5-f960-4e75-90f3-e7246a2cd295@riscstar.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d75b6bb5-f960-4e75-90f3-e7246a2cd295@riscstar.com>

On Tue, Dec 03, 2024 at 11:06:50AM -0600, Alex Elder wrote:
> On 12/3/24 2:19 AM, Dan Carpenter wrote:
> > Hello Jeff Layton,
> > 
> > Commit d48464878708 ("ceph: decode interval_sets for delegated inos")
> > from Nov 15, 2019 (linux-next), leads to the following Smatch static
> > checker warning:
> > 
> > 	fs/ceph/mds_client.c:644 ceph_parse_deleg_inos()
> > 	warn: potential user controlled sizeof overflow 'sets * 2 * 8' '0-u32max * 8'
> > 
> > fs/ceph/mds_client.c
> >      637 static int ceph_parse_deleg_inos(void **p, void *end,
> >      638                                  struct ceph_mds_session *s)
> >      639 {
> >      640         u32 sets;
> >      641
> >      642         ceph_decode_32_safe(p, end, sets, bad);
> >                                              ^^^^
> > set to user data here.
> > 
> >      643         if (sets)
> > --> 644                 ceph_decode_skip_n(p, end, sets * 2 * sizeof(__le64), bad);
> >                                                     ^^^^^^^^^^^^^^^^^^^^^^^^^
> > This is safe on 64bit but on 32bit systems it can integer overflow/wrap.
> 
> So the point of this is that "sets" is u32, and because that is
> multiplied by 16 when passed to ceph_decode_skip_n(), the result
> could exceed 32 bits?  I.e., would this address it?
> 
> 	if (sets) {
> 	    size_t scale = 2 * sizeof(__le64);
> 
> 	    if (sets < SIZE_MAX / scale)
> 		ceph_decode_skip_n(p, end, sets * scale, bad);
> 	    else
> 		goto bad;
> 	}
> 

Yes, that works.  I don't know if there are any static checker warnings which
will complain that the "sets < SIZE_MAX / scale" is always true on 64 bit.  I
don't think there is?

regards,
dan carpenter


