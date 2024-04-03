Return-Path: <ceph-devel+bounces-1055-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A17C8969B6
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Apr 2024 10:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE80A1F29D8A
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Apr 2024 08:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540336F085;
	Wed,  3 Apr 2024 08:59:26 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC136CDBD;
	Wed,  3 Apr 2024 08:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712134766; cv=none; b=V5eFHRFbbVzFKz0znA4W6E5ruWLwkNr75DUxf6/vOGaKCkDFxXNwojdaQsSIptfbCVhh8gU2ukpnyN+ZIBht+thcb03By82z3awF4L61ATQhnvn8GRUPemU8t6t4dfqE1KNmV2evD3tLDAZ1JC0+j7ZozV+BMPgnJC8kcwkws6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712134766; c=relaxed/simple;
	bh=Y8rTUim6wOz7dPyp+qzNx4sbsi7VJTk/kH/pv5IxOOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4PnKbdodhuN049J6SmRsAhIWj0XaaqaPs7Q/Ks1fZ25UN00AaAYdTsZURrlefNLTqvdQbt5cckoVRmqjXjDdDk7qRHXYtXBkFO7bIVH80WXhWZaMpOkJ2JvWhifqVx7AMtIUweIMgY2jKsItwpgThx8HIA1pJzwZ5702eqXA2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5FBB968BFE; Wed,  3 Apr 2024 10:59:18 +0200 (CEST)
Date: Wed, 3 Apr 2024 10:59:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Matthew Wilcox <willy@infradead.org>,
	Steve French <smfrench@gmail.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
	linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/26] mm: Export writeback_iter()
Message-ID: <20240403085918.GA1178@lst.de>
References: <20240328163424.2781320-1-dhowells@redhat.com> <20240328163424.2781320-16-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328163424.2781320-16-dhowells@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 04:34:07PM +0000, David Howells wrote:
> Export writeback_iter() so that it can be used by netfslib as a module.

EXPORT_SYMBOL_GPL, please.


