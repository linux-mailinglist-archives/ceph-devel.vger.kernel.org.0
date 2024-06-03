Return-Path: <ceph-devel+bounces-1249-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9CC8D7C52
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 09:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FAFA1F22B24
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 07:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9FB3FBB7;
	Mon,  3 Jun 2024 07:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fnNJiHwB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+BqH44Bo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fnNJiHwB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+BqH44Bo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB093DB91;
	Mon,  3 Jun 2024 07:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717399144; cv=none; b=i9/1TDXmonCPE52e/JgxS7goKwipvTSmL9za8HexAkxWlmaE+5lyZBcJaD8JYnnIFWX/fSYw17pMLt2ouxw4quR5tepmKBOy3EBHn+/01qUHAg5rRJy+5L9ZsPvq5+0rwCOvQvJ5PZxMvdoReAGjnl2EZvCl1dSDLrxIq0nJ1bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717399144; c=relaxed/simple;
	bh=pdJXbmmu4MBcZTg+r1XvCKHL1kTTZ1tDns8hoAXtzK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DskpCrYmckqklnSSUASmC0QiBZ8o64TEx7d/HyG1R9An1iBuNiQ8iW4Anxnb0RXdmq1+1JLtguv/9J8neVk+bSL8N6fyubSwgeGQQG7BCTb+xzx80Abv8tIMTno8BqVM5uP04xmHyx+VEPQOu/DyPRgivQnt+TGo2fClPHt3vBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fnNJiHwB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+BqH44Bo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fnNJiHwB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+BqH44Bo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 45EFA22217;
	Mon,  3 Jun 2024 07:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717399141; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rp339kq5sMQTQWuAgyY0m8zVUYDlI1+PpQaPOqzv8ng=;
	b=fnNJiHwBn3EBwbLR6b0INrZic0HiwD5nE/AzhTHwVemqKAr6wSxyvTmxhEzzhnhLhSytkm
	DhGpmdrtBdLLPPhMdRVouJrABaOrTPbFBlIt1RS3PwsZA4xOemteHineY8crjZp+56uiB0
	jO/ARokZxeBMqA7k0jXW38SVaK3ZjHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717399141;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rp339kq5sMQTQWuAgyY0m8zVUYDlI1+PpQaPOqzv8ng=;
	b=+BqH44Boug2vgP3fIw56KDp0Y7IfzweIa9mb3N/D/cFRGerQ8GiNxtTH2np83XLVaQLlvj
	6QmJY1UpMnYEMKAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717399141; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rp339kq5sMQTQWuAgyY0m8zVUYDlI1+PpQaPOqzv8ng=;
	b=fnNJiHwBn3EBwbLR6b0INrZic0HiwD5nE/AzhTHwVemqKAr6wSxyvTmxhEzzhnhLhSytkm
	DhGpmdrtBdLLPPhMdRVouJrABaOrTPbFBlIt1RS3PwsZA4xOemteHineY8crjZp+56uiB0
	jO/ARokZxeBMqA7k0jXW38SVaK3ZjHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717399141;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rp339kq5sMQTQWuAgyY0m8zVUYDlI1+PpQaPOqzv8ng=;
	b=+BqH44Boug2vgP3fIw56KDp0Y7IfzweIa9mb3N/D/cFRGerQ8GiNxtTH2np83XLVaQLlvj
	6QmJY1UpMnYEMKAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A91F13A93;
	Mon,  3 Jun 2024 07:19:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pZqII2RuXWakVgAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 07:19:00 +0000
Message-ID: <8fc3fc34-2861-429e-9716-b25b90049693@suse.de>
Date: Mon, 3 Jun 2024 09:18:59 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] net: introduce helper sendpages_ok()
Content-Language: en-US
To: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530132629.4180932-1-ofir.gal@volumez.com>
 <20240530132629.4180932-2-ofir.gal@volumez.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240530132629.4180932-2-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,kernel.dk,lst.de,grimberg.me,linbit.com,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 5/30/24 15:26, Ofir Gal wrote:
> Network drivers are using sendpage_ok() to check the first page of an
> iterator in order to disable MSG_SPLICE_PAGES. The iterator can
> represent list of contiguous pages.
> 
> When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
> it requires all pages in the iterator to be sendable. Therefore it needs
> to check that each page is sendable.
> 
> The patch introduces a helper sendpages_ok(), it returns true if all the
> contiguous pages are sendable.
> 
> Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
> this helper to check whether the page list is OK. If the helper does not
> return true, the driver should remove MSG_SPLICE_PAGES flag.
> 
> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
> ---
>   include/linux/net.h | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 688320b79fcc..b33bdc3e2031 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -322,6 +322,26 @@ static inline bool sendpage_ok(struct page *page)
>   	return !PageSlab(page) && page_count(page) >= 1;
>   }
>   
> +/*
> + * Check sendpage_ok on contiguous pages.
> + */
> +static inline bool sendpages_ok(struct page *page, size_t len, size_t offset)
> +{
> +	unsigned int pagecount;
> +	size_t page_offset;
> +	int k;
> +
> +	page = page + offset / PAGE_SIZE;
> +	page_offset = offset % PAGE_SIZE;
> +	pagecount = DIV_ROUND_UP(len + page_offset, PAGE_SIZE);
> +
Don't we miss the first page for offset > PAGE_SIZE?
I'd rather check for all pages from 'page' up to (offset + len), just
to be on the safe side.

> +	for (k = 0; k < pagecount; k++)
> +		if (!sendpage_ok(page + k))
> +			return false;
> +
> +	return true;
> +}
> +
>   int kernel_sendmsg(struct socket *sock, struct msghdr *msg, struct kvec *vec,
>   		   size_t num, size_t len);
>   int kernel_sendmsg_locked(struct sock *sk, struct msghdr *msg,

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


