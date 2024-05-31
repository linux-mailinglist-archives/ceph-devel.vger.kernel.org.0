Return-Path: <ceph-devel+bounces-1216-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F778D5B81
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2024 09:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1909B1F23E3D
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2024 07:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4173274047;
	Fri, 31 May 2024 07:32:38 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1F65588D;
	Fri, 31 May 2024 07:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717140758; cv=none; b=MU5jdRrYKkiUaqWTyCB5m0PtXeyvIMuTaRiXQ1T+HzaMhbfJItNYFNMSfv9pdSa5W3NcS4IOjExmzSNtgZdkqDvooMvbM6iVNzvOuZZkiqdNv63r+d78s1nphEFxxeevmvNpf9sYrPBs9P1YdpWJgNUWXSeJzKHawNi3/tAwKgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717140758; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfWfRPaBT4kYeHWQL9QvI3gWndH7KIq4YUCmGQRsgHL4wipiDVg5ixBs6WA1PDzkiLJw+uEn9IHICPY9z1U2AleD5uD2+Nrc/l+dBm/coqaWcFVTfVuc+3wnQk6RXS6iVevRbTO5ps7tny0eugeuPhq72S6yJqeIE8cuMzOPyq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 22FA468BFE; Fri, 31 May 2024 09:32:33 +0200 (CEST)
Date: Fri, 31 May 2024 09:32:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ofir Gal <ofir.gal@volumez.com>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org, dhowells@redhat.com,
	edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org,
	axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com, idryomov@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
Message-ID: <20240531073232.GB19108@lst.de>
References: <20240530142417.146696-1-ofir.gal@volumez.com> <20240530142417.146696-2-ofir.gal@volumez.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530142417.146696-2-ofir.gal@volumez.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

