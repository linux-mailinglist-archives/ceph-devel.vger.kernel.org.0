Return-Path: <ceph-devel+bounces-3507-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 645B0B4180A
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 10:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4A011B219EC
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 08:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC172E6CA0;
	Wed,  3 Sep 2025 08:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAmTNsU4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F152E717C;
	Wed,  3 Sep 2025 08:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756887016; cv=none; b=rnwnzwf+rwhvoUIBk4HVDiDRYsHl/qDwkJlmWls31fSgrvGJoqLPm5TlhJZo7HZN+K8xM+kfm30LHJwgNeNE77KKzyULSk3+qxrptwjALQzw4/RVSf8aARYMtPaYQrtffC1w23ftn5+/b0fXyQqyqGPmEImZAkTK5y3qu4BRrLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756887016; c=relaxed/simple;
	bh=VfaCq80owY5zLWJX+gDkWw66Sb+Orzm0ucUHP5iyN68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJ8kNJFORu95w66NPaOCElR95H7cxIpnIJZFI9cr2K5JBrZC7ndMnDOvu6r7uGf/K26WE3fDdF9X1kL/hUWmU/XSHg2BczV2BIv8BZFwJOibqLiQ6LY0qHDni8apF4nqoAeq8XIm/PNAW/v8RZNxpqNKyfzv+Te6Va7LcO2qwTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LAmTNsU4; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-329e47dfa3eso1412742a91.1;
        Wed, 03 Sep 2025 01:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756887014; x=1757491814; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8nLTCkRe0AkcGEGb8s2DM+RZJeechQxS5KtsRb6Dd7o=;
        b=LAmTNsU4QfA/pxLowxk3vQUyyQHQtMN/tB0tZfEiR8ZDHvuRkk9LSYxBzUs0UDJ4YL
         hJghnr7pmaAZx1xDjFgFQEfZAqVaGY8VIGqe0+E6vFUnFHofq/+9axiv0qxkFJz2XOrt
         pgWJlMrT5HeAmUQi16DWpJMmlcdFe/C7g1QJdZLa7d41Zupx1oLoT2dJ6c95/T7tOFQ0
         6YuUwI3moYvyHHWsZvtETiP83ZHZOtMgzFmQ2nCThX7QRoIIdjKJOihMlUGvpBP6HET4
         JO3J13L7ZWSXDoqa4pWhCrJM0IlvFwp+Imaue3iKIuw4anW98nOSH6N9dyJm97bTrl1G
         hmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756887014; x=1757491814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nLTCkRe0AkcGEGb8s2DM+RZJeechQxS5KtsRb6Dd7o=;
        b=OGStM9qo3rmQZ1WEBBdkL0bC84esAH1cnbxdAkKj5vHOIP5unFxr6NezwaPW72MiIW
         KpW0hL89HidBTRJGImNreJESenuLa1p2JTvPF9PqdwVNN8lpc64u7/WObv0cPEC24QkA
         ElISQVPG8L2nWekh0vH+MOe2Vz0F696DbYiPtFoMrU33iucUm2hGqYtJSPTLiK3JGBm+
         BW0PRTMoInrkwmTgBD5MpewO6vMEjQVP0vQQ6aNoiWssxcOGgybCGxMx8IBi5UaeGwCm
         3SKLkWo6cr8P5bTAWm0iPBbfVPb3Krm9DarTm+faZBCAEMeuKCmYM1G7+moSPadTdm4N
         0/IQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2xQvausUcgXMQLdL/zKNWgqueVLeG+i/yGLt5frn2QWE4yDKEwYACUDfC9dseACYQek0bdL2NNK6uzmQ1@vger.kernel.org, AJvYcCWbiF4Ch2oFJ3c/KiyyEVvWZMUJSk07PnICBQFyzKtr6XBdGjkx6CAYaK07eizGGDnaJiwdSXlE7j6J@vger.kernel.org
X-Gm-Message-State: AOJu0YxsaLRnim1pmsI5QXmlYY0THbLQxnrXsvRMoenWbiXjOviCAcs8
	jCpwqZ/8rSaWaF9rSg9T8CP2P78Vz23zxU7prnaiuopmIAE5LiXQagv0uL2Sso9b
X-Gm-Gg: ASbGnctii0fD2P6OQhBX70F/Ae+YxBlL4R6eYCs9ex8pLWpaNraNy70XFs6G4N1iuux
	kt3hlvk3zBjNt7iUcKWl0gkSQ7WUl9RtslNHm6rcqr6bcZCSuDQBmuPM/51uUdD+tEboYMquuJ2
	QPNg9K0gwmXvqWAu9Tmp58D1LPISLrEqfXBa9Pru/G9qSeskjVpDLsArJtMIpdTzQQWNIglRry9
	I+2zQHP15En9Uz+9j9vyfXWexcMNMeyi6w59pzuOyNpIUqH5PzRDJhHC1ZxujcdW5PfOpt8ZZhf
	Afds+ieZ6q3iTuJX2ftgONsN59JJxKTUedAggBgN/VBcdwIwx7xY7H0D6WmZLFWpfd9Su7oRHvY
	/1JKt5IoINV9d7Jd5sij92Kb69bt5qujXDWU8yYoZNFcG1rs5TZrLEzVsFfsK
X-Google-Smtp-Source: AGHT+IE8Tp+ko/yGOuPYB+iCHClScqH+Y6HDa2+oTz418oyuUhltMnIr5gMdAWkIiVssOpGt715qOQ==
X-Received: by 2002:a17:90b:5865:b0:328:a89:3dc8 with SMTP id 98e67ed59e1d1-3281543cc5emr18706748a91.14.1756887013677;
        Wed, 03 Sep 2025 01:10:13 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32b50a35ca0sm2491467a91.12.2025.09.03.01.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 01:10:13 -0700 (PDT)
Date: Wed, 3 Sep 2025 16:10:10 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Luis Henriques <luis@igalia.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	"409411716@gms.tku.edu.tw" <409411716@gms.tku.edu.tw>,
	Xiubo Li <xiubli@redhat.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH] ceph: optimize ceph_base64_encode() with block processing
Message-ID: <aLf34hrnwULGA+0m@visitorckw-System-Product-Name>
References: <20250830132822.7827-1-409411716@gms.tku.edu.tw>
 <fce1adab2b450097edbcea3ec83420257997ec00.camel@ibm.com>
 <aLdcNhKrPXxaEUtm@visitorckw-System-Product-Name>
 <f4f33ae461e0f1cf2f28d1c22546bd67cd9c4da3.camel@ibm.com>
 <aLf0eJcvCj9zcn-g@igalia.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLf0eJcvCj9zcn-g@igalia.com>

On Wed, Sep 03, 2025 at 08:55:36AM +0100, Luis Henriques wrote:
> On Tue, Sep 02, 2025 at 09:21:14PM +0000, Viacheslav Dubeyko wrote:
> > On Wed, 2025-09-03 at 05:05 +0800, Kuan-Wei Chiu wrote:
> > > On Tue, Sep 02, 2025 at 07:37:22PM +0000, Viacheslav Dubeyko wrote:
> > > > On Sat, 2025-08-30 at 21:28 +0800, Guan-Chun Wu wrote:
> > > > > Previously, ceph_base64_encode() used a bitstream approach, handling one
> > > > > input byte at a time and performing extra bit operations. While correct,
> > > > > this method was suboptimal.
> > > > > 
> > > > 
> > > > Sounds interesting!
> > > > 
> > > > Is ceph_base64_decode() efficient then?
> > > > Do we have something in crypto library of Linux kernel? Maybe we can use
> > > > something efficient enough from there?
> > > > 
> > > Hi Viacheslav,
> > > 
> > > FYI, we already have base64 encode/decode implementations in
> > > lib/base64.c. As discussed in another thread [1], I think we can put
> > > the optimized version there and have users switch to call the library
> > > functions.
> > > 
> > > [1]: https://lore.kernel.org/lkml/38753d95-8503-4b72-9590-cb129aa49a41@t-8ch.de/  
> > > 
> > > 
> > 
> > Sounds great! Generalized version of this algorithm is much better than
> > supporting some implementation in Ceph code.
> 
> Please note that ceph can not use the default base64 implementation because
> it uses the '_' character in the encoding, as explained in commit
> 
>   64e86f632bf1 ("ceph: add base64 endcoding routines for encrypted names")
> 
> That's why it implements it's own version according to an IMAP RFC, which
> uses '+' and ',' instead of '-' and '_'.
> 
Perhaps we could modify the API to allow users to provide a custom
base64 table or an extra parameter to specify which RFC standard to use
for encoding/decoding?

Regards,
Kuan-Wei

