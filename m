Return-Path: <ceph-devel+bounces-2966-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 728A3A680AF
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 00:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F225C19C7D47
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 23:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF8E207A0F;
	Tue, 18 Mar 2025 23:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B3CX7tlq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068A11DED62
	for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 23:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742340324; cv=none; b=C3YlWNd7kHQ0NYVI3K0R40g1NxRlMhtvr0ha903TpdGMxaUE9RCzet6A3BlQ8+hTXdsXgH7SlCYJXMgW1+5MUzMLTejCjGn5PeEWI/M0f+hCdVGgkMMEo3EUH+CXbaJrSLAJCNSpCDiSSeyURACh+evRbf96NyN99jMhZt2A+HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742340324; c=relaxed/simple;
	bh=PVeVOEoC5HectQ7ADqP9iOIRiReK3PqVNIuqNAYUKtg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iEJ514zSbg2o98LzoPaM25LSpdakIxZigAxgja0nSVyxs5uvkjJr05x70ImuHeZ4ex+4sv33midXxmoVsoiSwz3P6qihJqBPTRMD+oP+l9oS0jaAC8eOK0ytZZqOSo+ua8hozpjov+KadNBaD0WAho4BSVyrZ2+7kDiArh5ES70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B3CX7tlq; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22438c356c8so108461055ad.1
        for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 16:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742340322; x=1742945122; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Msfm87aWQui+ecgjjZCOowZlLiIuHpx6yURtqpa9/QA=;
        b=B3CX7tlq0psgrmPGA9HtCJQPw3+JQmM5F8C9t/PvcQboCuaG5cm+XZUCtk1+5oAPNw
         R43fUs30TempNBsLZUfv7cmlVRUHzJYLTUDWICmwIrkepX69pxri5IyDlgZu2lwNDCFF
         7I9QI4sjX5pW06A46EFN8pA8B52Q7igRoT6VFfYy//QQRGwNbhiORe+qcb6si2R4qbVx
         b2zAjlc6ERqWRLgNGUU0tM/wKAIvlnBDPXs9OJ+UechGvS8YzbvKQPJGNzQgFe1qiKXf
         8BYdoaLJBvxkQyX0YURC/9qd+c4f/GydDoHs6lb4ppB8GaK1QJdZvAaqCWxOmn5x95do
         +T1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742340322; x=1742945122;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Msfm87aWQui+ecgjjZCOowZlLiIuHpx6yURtqpa9/QA=;
        b=e3EK6zsjMAHObSnfy7+N5PSTM2mHgVXxCzzeLncUqS7zW7qHl0aHcL9t7YvHu+D48X
         T8AAm/eWB0OYB7+G0ABMQinEDiryNm2/Frlw8SbY7pPzsRysCYt9lbKYZrhtKzjSuH5K
         pSfVIpsZPfHgUnFAC1S23sSVmIkADxBKwa148PRv/rHFFJ+b5V7d9d7lkF6/yK4SXKnB
         UdLBYALHhroSeNzIj88ujCy9EI8D9NNFAhlFssx6ulK+d1iXWU41BzEjiAIql3oL4E6a
         BFcE/+LAhqbEx8JEOmJwAklFdTVDPiftD1+uAj+of1+ETm00vyY9fiHG5DFPbc2IVKLO
         ckwg==
X-Forwarded-Encrypted: i=1; AJvYcCXsc4C+J2h8cfomPt/L5p6k+zUv1sFuYQkz0O2B8+gxVb9Zlbw9MBX/4+Xm+klz+NR8fRL7kIneKf7D@vger.kernel.org
X-Gm-Message-State: AOJu0YwyUzQaruct86L6vtp2LK/FHls15u/s6DopkgEXV0dddxZBocqC
	my1AGJdZmqWKWc/TTP+KMP5g3frI4//DEj3rKlGHF3VpN8k3fTBP
X-Gm-Gg: ASbGnctvQD9NeCFfxoDBjNUfwYmNoUHjBdG7ZM/vPe57HKDtLsPAHbeq5LDwYEFm6/r
	5kJrMbMd5JDxCykHWNDJZxzE1xQ0Lna1PRA/MIZYe1axL3nt6tu9nMvlhGIw9gUs8ortcajqT5v
	75koWd4b2UH3uxu5HaZv8wughLPPJ77NH+L5jxdNevcLYifBPC9WtpW3Y76YaHmUrOKmYRsBMBE
	dfMN/vfOTkZei2ZzOb97rwLQIX28cIylbnwlz64e62639b7KYuVrAj58bvkYnDrAlqt2QGDIlky
	wr/E/VUk1qQIhpYnKImWMbWx+h3jQWFC/6D+U3g=
X-Google-Smtp-Source: AGHT+IHeij8/r4S7NVtp24J3wc6l3UqxasuKytyc2bLKO0m9THTJv5f8sjLl+nQUb82p00pA8/kGGQ==
X-Received: by 2002:a17:903:1a23:b0:21f:8453:7484 with SMTP id d9443c01a7336-22649a3c625mr6393635ad.30.1742340322114;
        Tue, 18 Mar 2025 16:25:22 -0700 (PDT)
Received: from debian ([2601:646:8f03:9fee:5e33:e006:dcd5:852d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bbca45sm100720235ad.166.2025.03.18.16.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 16:25:21 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Tue, 18 Mar 2025 16:25:19 -0700
To: David Howells <dhowells@redhat.com>
Cc: Fan Ni <nifan.cxl@gmail.com>, slava@dubeyko.com,
	ceph-devel@vger.kernel.org, Slava.Dubeyko@ibm.com
Subject: Re: Question about code in fs/ceph/addr.c
Message-ID: <Z9oA3xSwEQgWzZ83@debian>
References: <Z9nFlkVcXIII8Zdi@debian>
 <Z9m7wY8dGAlq4z0K@debian>
 <80300ccacebc13ee67100fe256b03f08dfd2819e.camel@dubeyko.com>
 <2681465.1742337725@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2681465.1742337725@warthog.procyon.org.uk>

On Tue, Mar 18, 2025 at 10:42:05PM +0000, David Howells wrote:
> Hi Fan,
> 
> My aim is to get rid of all page/folio handling from the main part of the
> filesystem entirely and use netfslib instead.  See:
> 
> 	https://lore.kernel.org/linux-fsdevel/20250313233341.1675324-1-dhowells@redhat.com/T/#u
> 
> Now, this is a work in progress, but I think I have a decent shot at having it
> ready for the next merge window after the one that should open in about a
> week.
> 
> Note that there, struct ceph_snap_context is built around a netfs_group struct
> and attachment to folios is handled by netfslib as much as possible.
> 
> My patches can be obtained here:
> 
> 	https://web.git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=ceph-iter
> 
> David
> 
Hi David,

Thanks for your information. 
That is very useful information to me, since I am still slowly ramp-up mm work and lack
of the whole picture of mm development work. 

Just to make it more clear to me, so that means all &folio->page and like
will be taken care of with your patches for fs/, right? If so, I will skip fs
and try to work on other sub-system.

Fan

