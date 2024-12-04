Return-Path: <ceph-devel+bounces-2245-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C889E41C4
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 18:36:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 528CC28526F
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 17:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DB720E02C;
	Wed,  4 Dec 2024 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BcuUxkny"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E73227B83
	for <ceph-devel@vger.kernel.org>; Wed,  4 Dec 2024 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331951; cv=none; b=JE4ddI34EtCqBsLz+d+oDz04t39KWLipLS00c7fH+MH3nw46hJ50uVp3VOYiyg1RbMflK0vq13Jme9Muab9J9KSDwAIjrrzJEknT9elER7BZMNaEhkYjDeOERdUV8gKfgtT5h/wjjvIz+ufJY6XUvJ1pTEsgT+1SgxvQs7nNKfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331951; c=relaxed/simple;
	bh=0QtLt9PSiwx1JLB1Npkyn53s0WOU8BRBUbIsZ2SnirU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4V/OdyCGnT1b2D5WWBmgqWnc+KbmU17Bx1OiWHsmhJlgy52JdfpqsQAtj2xrIEKFRSzDUz9vVKMOYC5BUN+35TIrs71EaqtMMdGHCiy+yi28BvVHPF+TyHShG4629ear51WJs4Yp8yv0iNQ4AqYUdh9FnUDD38aErL3+LWHpvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BcuUxkny; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa520699becso1113315266b.1
        for <ceph-devel@vger.kernel.org>; Wed, 04 Dec 2024 09:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733331948; x=1733936748; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6/i/353RZWcy5pwytPE5ZcbdTfpw1IJrIN5dUji+6IQ=;
        b=BcuUxknyNxrq9dlxaTbVXSr3ouM3blE4yUQ2+32SErxT5TygvltCwEhgs35uVsq7hU
         DvqqTuH3bVKBODktNoN5FO4XqC7HEfCjav9INtkLN2lEUxepqjRO3x0RSgScoV4sDhY8
         y4v30PM5B4d17LOm5U7OD1mBHKwkhbF4ETOLYBhQl1LwvlGBzzYNX5S4tu3c935/EAAW
         Jyv8AgI8iQvh/WOoAeg4dGtZa64N6NQOWuSlHEw/RTyCAB5AcQ9wO/b6r3fC6miXQWlC
         GX92XwEpOJz82G7oTmeDU85nurvliQ2z/pqSq4sDXVou8Oy2YU9O4aDG1WY9AvVX37Aj
         o0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733331948; x=1733936748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/i/353RZWcy5pwytPE5ZcbdTfpw1IJrIN5dUji+6IQ=;
        b=wsW9iUPGaXsfmoN9Jq7DJCAsxqgyuLtOqEqKlUdkXSYN37cmP4RdZjbg0zvsoIua8L
         /fk3jM25tIGAXt5j72/BLnWau23tCoDTNXE3TKmoo4mEPKWd3SKYigJiecUtmdXAHlyO
         l2kt3Diwopqz0y95r4f1L7m5/mGXYkqOgRNpMdaJ/f0PQ/tkErd/0cYdERi9ukGyMC8g
         nB5T2lef76LvYdFacC+UhlAYZ9DXOu+a/knbLnw5KQ8OxQWPxlF+MZi5dzA9jajSwYSA
         lw/7lgs0CJxqL4C3kBagq6BBAs+4Gdnt/BwN0XC4XaltsoEazV1n+MJsHzlq3cfgESg7
         UHqA==
X-Forwarded-Encrypted: i=1; AJvYcCU0B7klnwJcrojMQMS6jUU+yuvW4/7vKzTvxH3wXE0Kz6h129iRSf901pLuERDJ4DkTTB9fl6gc1W65@vger.kernel.org
X-Gm-Message-State: AOJu0YyGaIze3nii9pscetAfQ3zeQzUERvw5EMVI0nWIK5uXQyf2P0nC
	q++Xl+iQqkS03AlRAStUYU1otu3ddcEAZkGm4NHIzAxkBA0ns+erRYv2xQAH7UA=
X-Gm-Gg: ASbGnctfinNhncC000kWJ31OqjIsex4qfImYhe1vYc0+rQqczVUu1Sxi9PoFl1PIR+Q
	IisC12YKvRsSeHFW3sD5U2dhkgTkmuque9EOKZounVg4p6y3oxpsRgweyjewG+HYpgTEBwWKIVX
	7KWPST1AWAN2egtLrFYOeVgMRjW3xp6WP36aTA85AB8E6zzG7nxWlK3hDKkykxRG/pCEGpQClgc
	CWSzZRoucZvMAbN/UzENuGSOxMPOP1VqoN7T5ZRUJYz3B6Dy896YwnfnYc5IuxZ3nVmfyFyIg==
X-Google-Smtp-Source: AGHT+IGarUp3CvGEIR9mPITengO1D5uf6ORwAzVSYM4mMjgUANbHRzLGXnMHScr13MpYdrOkzmA4QA==
X-Received: by 2002:a17:906:30cc:b0:aa5:3853:5536 with SMTP id a640c23a62f3a-aa5f7eedf5emr539048766b.46.1733331947815;
        Wed, 04 Dec 2024 09:05:47 -0800 (PST)
Received: from localhost (hdeb.n1.ips.mtn.co.ug. [41.210.141.235])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa59990a7b2sm749830766b.169.2024.12.04.09.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:05:47 -0800 (PST)
Date: Wed, 4 Dec 2024 20:05:43 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alex Markuze <amarkuze@redhat.com>
Cc: Alex Elder <elder@riscstar.com>, Jeff Layton <jlayton@kernel.org>,
	ceph-devel@vger.kernel.org
Subject: Re: [bug report] ceph: decode interval_sets for delegated inos
Message-ID: <bb34b6aa-730a-418d-bb25-20ad003779e6@stanley.mountain>
References: <e660f348-5a0e-486d-8bae-e6c229f0e047@stanley.mountain>
 <d75b6bb5-f960-4e75-90f3-e7246a2cd295@riscstar.com>
 <a7f2d7f9-014b-4535-a0d1-74c351d13eca@stanley.mountain>
 <CAO8a2Sjkcmqr0Big38Dqia2XZFHVhbukWhAJXYh4Y3VPFrKcaA@mail.gmail.com>
 <CAO8a2SgNuGyvH+jcCbaVO0p1fRfOd7_Kuo9MuUDCnDwxNt1SoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO8a2SgNuGyvH+jcCbaVO0p1fRfOd7_Kuo9MuUDCnDwxNt1SoA@mail.gmail.com>

On Wed, Dec 04, 2024 at 03:12:31PM +0200, Alex Markuze wrote:
> Dan, how are you running smatch?
> I've been looking at smatch warnings/errors and don't get this error.
> Do you have a custom smatch checker?

This is released code, but there are two possible explanations for why you
wouldn't see the warning:

1)  Are you using the cross function database?  Each time you rebuild the
    database then it adds another layer to the call tree.  EDIT: But
    actually in this case, it doesn't matter because Smatch hardcodes
    ceph_decode_64() as returning user data so the database isn't
    required.

2) This bug only affects 32bit .configs and I suspect you're building for
   64bit kernels.

regards,
dan carpenter


