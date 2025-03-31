Return-Path: <ceph-devel+bounces-3000-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CAC3A7616F
	for <lists+ceph-devel@lfdr.de>; Mon, 31 Mar 2025 10:24:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 980E91886B6D
	for <lists+ceph-devel@lfdr.de>; Mon, 31 Mar 2025 08:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 944991D89F0;
	Mon, 31 Mar 2025 08:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QBIqNIle"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889AD1D6DBC
	for <ceph-devel@vger.kernel.org>; Mon, 31 Mar 2025 08:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409421; cv=none; b=LA5E0/6J2moQFwB2DljxQkpuQorzcTqPmaL1lMcPD70g0aEdUOIUTcFeKYxApeEHDxbmlIZFt0DgzKR6htjbLaWBbkwsNkNs96K9PXaBkxn2UGSx1/vbKUgxfZROGh5iKSuNxm4cGq0VlECmKc2PhxxeM+Rm/aYMUvGNLQ6v4XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409421; c=relaxed/simple;
	bh=tydjkUm1MWoPcJbw9LlS45LEZRiPM3MfaIlva5bJBN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nVCBgHLJrdyG9FtTTBvXVDBVlaOzqg67AhmRl25phv1z7i+AwU+EQE21pGFA1csOfZqCqevokkMXIubF67Z2siMOSgd6e8jib+7CEKa4ftFRKylMZqgwBrHkOLWK7rYBBPLDh3D74ZRrJkOlaMYpkRVVpkrxZ9S+orgS2muO/SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QBIqNIle; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4393dc02b78so25910055e9.3
        for <ceph-devel@vger.kernel.org>; Mon, 31 Mar 2025 01:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743409418; x=1744014218; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7XzAbMJKsyqCvYLFOVx+4nb8BpQlUBvuCN2BfbgjctA=;
        b=QBIqNIleMAn4b5Z0pt6iZaXLwwBR5vcel7Y+3XutIHugOziNDALMcZ6MxoQS/GOJfn
         W8FbSBfcCku4MrLYkWi8JhdfGPED3ul5BrJypCpNQa87GjL8pw/QGez+iu9JrZRyNg5g
         l6PcMj8JtZsU0vupoJwWm2+zFwkZhuKKryxD2tlDhkx2K2agkFwyG/qfQlGXEkS7dEIZ
         aGrp0qtAuSy7PLfQJTwpGbspkPA55ypxbJ6nbWnEZXkDISxl6TzQNIAbCanGnW7kYJ+c
         tbQcmQsVpymKjWF+6Y/sIXgCODq3IrXtOkWVaFPauuAJ+LW69BBzD0lITuG0gUn2e00y
         +zUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743409418; x=1744014218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XzAbMJKsyqCvYLFOVx+4nb8BpQlUBvuCN2BfbgjctA=;
        b=mQv+4SWSORRrns66QfZ8IuztApwvp44knS8OHqAaZ1Be2Dt1xjGqoGALrTHwUCpNvM
         i/7hwv/LQCXaM+dqYjI2yfsi3i8jcw5xl9MWaqx1ad99BqciODp+URHQ4znXo4lIvl3A
         WwiVkj0DPo8gY47KphKM3kcu4kn1DeADzOCzKDrq7td4WTkt6i+PmA1q4jrBVDI2C7pw
         vfeUzOR+xeLBNvqqEQ95yH53Lknb1u/pLqkWMTdA8kZ18nYXqKCdfh/PkbdVCWuD32Ph
         u+PcwyWS3NGZtEdYzLYRAWj9y5QxY9htZZpX1EERACMmf6+RjbLzjOhMAvIGx+2kgo55
         asog==
X-Forwarded-Encrypted: i=1; AJvYcCUgaSzyWSTY8VaqQV5DsDQrW5OK3RNjev8CVaJHWspPLVr5em7Cb5pMYjfHce+yY/EOTqSHa0XxRhum@vger.kernel.org
X-Gm-Message-State: AOJu0YwDX6J/XdPGZlNangscWKnVLdUpwTdmX7ZYbmfJTS9jkiGH2Jar
	wQUyvK6SiNRAsYLu/kqk74dX1ePcP+qCsK3QtmAXWUblPeAd/O507LRaeh14r2M=
X-Gm-Gg: ASbGncvThklyi77nPNRvI2k7kAKwqdJ+gxIszzbLGLngLGXoUKASDj6bGTtA2KkJkSY
	rnFYhwPArzcxvdtJvy43AWqpUIJ8J4NohJMph2qmM2mxbeRCGbJ9J7wB0pLE/kQWdgXXmgGkjUK
	bi3LIcW1XVIoz0J8Sp4lG9ik2MEXC+OQ9lOHiYt0S/yVtCRuEftTyG/Tm6Yw2dM9X5+Ij5ei64F
	ADPZBC3OZ3er3d2Z/mvPd0RQLaX9xREDYpM9u+HlThibPuWaMljBYB5nDNyb4cbsm4mMxcEw2N8
	0sPrawhrJkmDrIojktONZVo5+i26oFEeBGrSYqGz4HbXtEARpKp/4Lzy2z/l
X-Google-Smtp-Source: AGHT+IFgpeNUpBNYq+DGAF/behYR3kaDePcRPqnxNTpDQLiUg5Abgd7en5WRr361G/zWw5nYs6ivdA==
X-Received: by 2002:a05:600c:3d13:b0:43c:fa24:8721 with SMTP id 5b1f17b1804b1-43db61ff059mr77133175e9.17.1743409417894;
        Mon, 31 Mar 2025 01:23:37 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-39c0b7a4294sm10400966f8f.89.2025.03.31.01.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 01:23:37 -0700 (PDT)
Date: Mon, 31 Mar 2025 11:23:35 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org,
	dhowells@redhat.com, idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com,
	amarkuze@redhat.com, Slava.Dubeyko@ibm.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] ceph: fix variable dereferenced before check in
 ceph_umount_begin()
Message-ID: <d6d2f186-3156-41bc-88ef-c18ef8836bdd@stanley.mountain>
References: <20250328183359.1101617-1-slava@dubeyko.com>
 <Z-bt2HBqyVPqA5b-@casper.infradead.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-bt2HBqyVPqA5b-@casper.infradead.org>

On Fri, Mar 28, 2025 at 06:43:36PM +0000, Matthew Wilcox wrote:
> On Fri, Mar 28, 2025 at 11:33:59AM -0700, Viacheslav Dubeyko wrote:
> > This patch moves pointer check before the first
> > dereference of the pointer.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Closes: https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_r_202503280852.YDB3pxUY-2Dlkp-40intel.com_&d=DwIBAg&c=BSDicqBQBDjDI9RkVyTcHQ&r=q5bIm4AXMzc8NJu1_RGmnQ2fMWKq4Y4RAkElvUgSs00&m=Ud7uNdqBY_Z7LJ_oI4fwdhvxOYt_5Q58tpkMQgDWhV3199_TCnINFU28Esc0BaAH&s=QOKWZ9HKLyd6XCxW-AUoKiFFg9roId6LOM01202zAk0&e=
> 
> Ooh, that's not good.  Need to figure out a way to defeat the proofpoint
> garbage.

Option 1 for procmail users:
https://github.com/wjshamblin/proofpoint_rewrite

Option 2: Copy the tag from lore.
https://lore.kernel.org/all/?q=ceph_umount_begin

regards,
dan carpenter


