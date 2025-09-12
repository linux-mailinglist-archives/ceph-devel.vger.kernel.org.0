Return-Path: <ceph-devel+bounces-3600-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A601B54433
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 09:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 203767B8673
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 07:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863062D3739;
	Fri, 12 Sep 2025 07:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="NHfPqkBO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592CD2D29C7
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 07:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757663494; cv=none; b=j2CS7+FERUY0IOBnBiGkg/2Q+NvDwcb7IqTR6IuoOdmfa6WR7iE1F2looA90v76SxBFWgZfN7lo+iB+GMY4IRPe4JJ7HZbzLofAELaTCdjvGt8DZztljbPy7uVTZ0eyaZ3iHfM2tDEHSiWnxMMYlc5dlSu2x1kdTa21JXHfGkvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757663494; c=relaxed/simple;
	bh=/nCOtAcnhP6iXsdPDKExHl6CEK70Rn3V1zWzjtGkAjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHVXZi7I66nQBAWq/Kw1DUbDRp9jAYndjVSycaC22DjbrGVt3tkZ2+bKu9UOjsJi3HLr6D9pl9+TNPtH23PrGm6z5OaJdHI3wyu9LiYFuTVRSkX6pUDL03Emkyx6N9ChYJa9Apny4ueTX9ORlOBUM8gz1EeC7p33l6J1N4p7koE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=NHfPqkBO; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-772301f8a4cso2229790b3a.3
        for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 00:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757663492; x=1758268292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H5dGuAanKwsiY1ZqsKVkDAIjfNLSeHC2vPf4ogltoWw=;
        b=NHfPqkBO6IpVqSz6f+1Cnc18yRXdyF9DjK/HXMiE6pXswUizb6G8718m76bb+VW5Rk
         QDHXyq5y43TSQR6JQfKncB1ydlE+HLHQQahiRz91cbKABkOjtRDIxC8SJ7dou8ufBDD/
         scfhgN9ujlASqXvtj3UjnEfqkHQnj0gveUfWcIWdKbXxDW8vo81Wuf7eEpen5AGRH1Rg
         IHRxLGMgB+Fp/dp3mA71hr22XWxdo+l3S0+CV16HVlyCHKCHJYKOK1zS09zNQ4Mh7iAD
         zK9EB25ddpb5qr0ZC+ifHbZ1DoGE4q0DqVIIqYjeaMG4ToJktcYGlsHiPxpfqOAT9dBG
         /T1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757663492; x=1758268292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5dGuAanKwsiY1ZqsKVkDAIjfNLSeHC2vPf4ogltoWw=;
        b=Muaq4aA+AfjdxJ3mc/vdfwHWD7KbMY8V/1j4bZ6zPDE7S5ncYzDsAYqV7zbUV0OUt8
         XqBqISE4cqKdDvAzCYnrO+45OA8BzVS7bvnh9uBo0GNyqJat0YhQc6OcuTqoEcE006td
         EMX3vnQeer+7UEI0izUINVOHvJzJPPi+Y6ijEVIDiL3I4NkOyBAP25saZ4cij7V2VSj8
         NRIoeWbPz3gwRHQY2wuzjj6Z4phBkCqlQdMIRY33O1o7dvyFiRHiTzqkIwkAyExtC895
         5q+IIWRKVlBSyj3hIK/zFDmoJ1CTF0tN95ETXQxi0g/0AmLIExq8AV80o/cynSEwwjJI
         Xc7A==
X-Forwarded-Encrypted: i=1; AJvYcCX2pDLswAKM7KVm9t34mssyqUZsQWqkzCx4ASiTMX5/r93Pyzmo+aEawF8f0WUFy6y16e0BrB8rRcng@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0DBcMRU0XtriPmAd7s8Z0M5+E1w084VTPN5TExuGTwY2lVAxV
	I3KJDJXI3qtWSyWVChlVcsQlVRflwOBZnW37PmAwftN+UZ7a32hr5RSYRnstELs3bAM=
X-Gm-Gg: ASbGncsv+NNZCg0Tzm/VSXwyBv4hmJCRYcom9WnO4L/inTCShVib8WW6pGHPdkGpZhR
	BwHVsZ4IPppEWvodSNxnLciaIcl7FFjMUqRmRy9yY2iacbjqkWpx5o+/jlqpgHyoIWu2anXL9Ji
	4ICFJcYQylnEpIQ9ARi3yp4FLPIWk777ornR6mdTsA7WBLJLIqbrynkXprfd6DUy2HvzSaicY+G
	OSfIv1r62ZRPm9/z5VUB/fx9MDmV5vskaLwZA0xCY0wopr8Qa9MUp69J3f/bbHRB69JIThoeCTF
	p+gMtK3mP/99eyesuNRs650I98RTuq4lfkFcgsksO6uRPaOocK8RmMMqv8OqdHbgboNYrrZ5RuL
	zuo3HzKg3PNP87hozXlYLjwH4SWr/wGMMM5296SGsKpRh
X-Google-Smtp-Source: AGHT+IFtDrLHbUf9AliWqdyLS/y+bqUNiq48Oi6Y5dHmTb/VowvDyGiDtwNlsYwwblHsCPFZzZ+p4Q==
X-Received: by 2002:a05:6a20:7d86:b0:24e:a19:7e91 with SMTP id adf61e73a8af0-26029f9e7f9mr2593600637.5.1757663491712;
        Fri, 12 Sep 2025 00:51:31 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:9e14:1074:637d:9ff6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a3aa1c54sm3880886a12.50.2025.09.12.00.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 00:51:30 -0700 (PDT)
Date: Fri, 12 Sep 2025 15:51:26 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Eric Biggers <ebiggers@kernel.org>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
	jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 4/5] fscrypt: replace local base64url helpers with
 generic lib/base64 helpers
Message-ID: <aMPQ/sJJmgpZvDsY@wu-Pro-E500-G6-WS720T>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911074556.691401-1-409411716@gms.tku.edu.tw>
 <20250911184705.GD1376@sol>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911184705.GD1376@sol>

Hi Eric,

On Thu, Sep 11, 2025 at 11:47:05AM -0700, Eric Biggers wrote:
> On Thu, Sep 11, 2025 at 03:45:56PM +0800, Guan-Chun Wu wrote:
> > Replace the existing local base64url encoding and decoding functions in
> > fscrypt with the generic base64_encode_custom and base64_decode_custom
> > helpers from the kernel's lib/base64 library.
> 
> But those aren't the functions that are actually used.
> 

I'll update the commit message. I meant base64_encode and base64_decode.

> > This removes custom implementations in fscrypt, reduces code duplication,
> > and leverages the well-maintained,
> 
> Who is maintaining lib/base64.c?  I guess Andrew?
> 

Yes, Andrew is maintaining lib/base64.c.

> > standard base64 code within the kernel.
> 
> fscrypt uses "base64url", not "base64".
> 

You're right, I'll update the commit message in the next version.

> >  /* Encoded size of max-size no-key name */
> >  #define FSCRYPT_NOKEY_NAME_MAX_ENCODED \
> > -		FSCRYPT_BASE64URL_CHARS(FSCRYPT_NOKEY_NAME_MAX)
> > +		BASE64_CHARS(FSCRYPT_NOKEY_NAME_MAX)
> 
> Does BASE64_CHARS() include '=' padding or not?
> 
> - Eric

No, BASE64_CHARS() doesn't include the '=' padding; it's defined as #define BASE64_CHARS(nbytes) DIV_ROUND_UP((nbytes) * 4, 3).

Best regards,
Guan-chun

