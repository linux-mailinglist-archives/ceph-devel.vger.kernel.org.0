Return-Path: <ceph-devel+bounces-1861-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FDFA98AC75
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Sep 2024 21:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 005F228204D
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Sep 2024 19:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E65199E80;
	Mon, 30 Sep 2024 19:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b="AD2ZcWHJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119C419992D
	for <ceph-devel@vger.kernel.org>; Mon, 30 Sep 2024 19:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727722823; cv=none; b=sdlinNbbihpXLT0vq2KnZ2IEBi4D+xVljJtljAil5TynDj0qrvA6hHHBVUM9/HLy0mBXkQH9a4eF7ZqwfDmfWuJwKhJB88kpQvQhfKN2LKH4VkiKK1kUWT2wMKfDn1yqARRdTGaWrtJNBHbgtolw6W6XMRmcZ9EqcRgZkWeWXxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727722823; c=relaxed/simple;
	bh=UTeuYgMehmLJA/arPzgIQes3j/4SwwxcY8cev10CXXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+45T/17UUwnDD9n+z6BYwnlhMoF4bmy7W6M+snDu3REzDmakxUSpEX6zVmy4H2q2H2hTVgLX/LzkCBokHF1xdj/aZzj8A+Ux+s+Z6AIH9W7WTrILVGUXMdZEtfJqqneLMXd+vM2FvZv38hCrWra++vQpMwNjmLSI8ZKWqEwDV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b=AD2ZcWHJ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71790698b22so645256b3a.1
        for <ceph-devel@vger.kernel.org>; Mon, 30 Sep 2024 12:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1727722818; x=1728327618; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tK4zHMv9BgdsXfJFkQFkyqT5Q9MVxMalN7pOJK+VYMc=;
        b=AD2ZcWHJT/Eh8QCoGwtR2mU/72Hn5PXbAqIORnZDyFQ12uCk5B6tgPR0gvJL4FDpmJ
         ulZzhaj/oQ9sKYNODSjhgVv94UWmTt9EA+rp3AZxM3D7FuMreK9zLBVPVKWu3uh3+yR+
         vy+EFC32Ma8cvowRGq+XAGeEadeMV+x3qYlOPzmGn6BqAD76WPYrQPop8bkeDhZ4ERpK
         1UNXgJ0vFc4lVx8afjUXBo0LvvB6Rd4zof4t3Zc6Vy61FsDUmw+QDwS60x7YioxFUGH3
         CoTsxWXSnHhGL7i7+cVMdkBzfJQ1pVAYBQUJy/0cBhT0hau1JKlewvZ94VVeJ6zOGv4q
         0Crg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727722818; x=1728327618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tK4zHMv9BgdsXfJFkQFkyqT5Q9MVxMalN7pOJK+VYMc=;
        b=Pce3EMOxcS/cHbfJ9FM7nGdJvO3Mgu4lBSrH3kft8RinvWgDqR6+zSzhxEuq9wpcxj
         5a498gkJpyc8qiG8d8Z716N3XFmOaMKdNNFjDdyoAJ4dgC/tMTi+0UpePieB10j8LFvL
         d1Pd6/BSy5G1nSJM+ChliRf4kd9yz2Tb+AsW1zq3/nDGnmTTvUdkhKYUDlOO6o6C1AVQ
         jQJyunq5E01SHwn8l/Uir3QjetlDm6dQTZ6DUFHLFUTk0Rfnd71JX4ZB2PmtfxULV0/W
         KUu18RSOtGCaEjE9KY9ilWUVftoym0kI576VrNzs1JsSIdLbdB5nKUt4ijByBkR3hswT
         SnEg==
X-Forwarded-Encrypted: i=1; AJvYcCV5bzS77eIADkGf6Xtidq0PjeKUkA0OWL9Z1ovsGCcs44wNYi2NCTPm0O0EObM+fW7u0LMXXFu6VNtY@vger.kernel.org
X-Gm-Message-State: AOJu0YwUkUhL2j0ydPVseQVW66SWLwHF/q9fr3xHDkRgIIx5cID+xD9x
	HglJaiNivV7ttaFgOqO2ZzoxPKJqihTB7J2Zs6SLf+CMNu62DrPByHwPFw/22s4=
X-Google-Smtp-Source: AGHT+IHr3t4octArrJkwK4KlggdiRYNEixY4E7CvOHzMJxxuBtEfGjyLTrjjT9DROP00qxEU234jog==
X-Received: by 2002:a05:6a00:2392:b0:718:e49f:246e with SMTP id d2e1a72fcca58-71b260a8a3fmr8397735b3a.6.1727722818090;
        Mon, 30 Sep 2024 12:00:18 -0700 (PDT)
Received: from telecaster.dhcp.thefacebook.com ([2620:10d:c090:500::6:e49b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b2652a622sm6544654b3a.164.2024.09.30.12.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 12:00:17 -0700 (PDT)
Date: Mon, 30 Sep 2024 12:00:13 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Howells <dhowells@redhat.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>, Leon Romanovsky <leon@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Manu Bretelle <chantr4@gmail.com>, asmadeus@codewreck.org,
	ceph-devel@vger.kernel.org, christian@brauner.io, ericvh@kernel.org,
	hsiangkao@linux.alibaba.com, idryomov@gmail.com, jlayton@kernel.org,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nfs@vger.kernel.org, marc.dionne@auristor.com,
	netdev@vger.kernel.org, netfs@lists.linux.dev, pc@manguebit.com,
	smfrench@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	v9fs@lists.linux.dev, willy@infradead.org
Subject: Re: [PATCH v2 19/25] netfs: Speed up buffered reading
Message-ID: <Zvr1PVRpC33aaUdt@telecaster.dhcp.thefacebook.com>
References: <423fbd9101dab18ba772f24db4ab2fecf5de2261.camel@gmail.com>
 <2968940.1727700270@warthog.procyon.org.uk>
 <20240925103118.GE967758@unreal>
 <20240923183432.1876750-1-chantr4@gmail.com>
 <20240814203850.2240469-20-dhowells@redhat.com>
 <1279816.1727220013@warthog.procyon.org.uk>
 <4b5621958a758da830c1cf09c6f6893aed371f9d.camel@gmail.com>
 <2969660.1727700717@warthog.procyon.org.uk>
 <3007428.1727721302@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3007428.1727721302@warthog.procyon.org.uk>

On Mon, Sep 30, 2024 at 07:35:02PM +0100, David Howells wrote:
> Eduard Zingerman <eddyz87@gmail.com> wrote:
> 
> > Are there any hacks possible to printout tracelog before complete boot
> > somehow?
> 
> You could try setting CONFIG_NETFS_DEBUG=y.  That'll print some stuff to
> dmesg.
> 
> David

I hit this in drgn's VM test setup, too, and just sent a patch that
fixed it for me and Manu:
https://lore.kernel.org/linux-fsdevel/cbaf141ba6c0e2e209717d02746584072844841a.1727722269.git.osandov@fb.com/

Thanks,
Omar

