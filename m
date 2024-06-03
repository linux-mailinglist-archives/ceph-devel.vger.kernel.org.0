Return-Path: <ceph-devel+bounces-1250-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 759D08D7C5D
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 09:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E48991F22BB2
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 07:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D4443AD1;
	Mon,  3 Jun 2024 07:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HxLZlnwB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TpIhuXrQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HxLZlnwB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TpIhuXrQ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405AD4084E;
	Mon,  3 Jun 2024 07:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717399377; cv=none; b=iUMrssQKhnQqvGXPUtKfG61RxD0fGtSKH3ytX26d17x5Xxe6OxkoxTVg1I6CrSXLS9K4twUDLNZJMoxM72aZaagMadqxGgkc+xzSqfyH6v+WK1Q61S7gHQLM8QUxrLVXoj27Pv4FlKSBQCristj/ErN/r7DP5I5gmyIzX8/OGbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717399377; c=relaxed/simple;
	bh=IIFD8hCO543FuGSSZ3N1AxeBeDbcUct6DWdjvi03m3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jq5SNAItGKmO+1eFmyh6EJkiHaDKWj9/tCuWvrhVnKLYN2tBVwhf2EuVFSeDUkdFnV7ALggrtflB9A0Lkhw+BEAkW4bFkgN7akQOBRhhVeryBCXwySMTDhZ6hbMUaXi1Nh7dkhw6cb/ysnWelDy4G4CELIm9FO37B215jKv2aD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HxLZlnwB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TpIhuXrQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HxLZlnwB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TpIhuXrQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5ABEC2221A;
	Mon,  3 Jun 2024 07:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717399374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5QpIqfLnJmZAO1whz9lIXGN+ri4N7A336dW2TxOKdI=;
	b=HxLZlnwBB2TkzeR8grhT0rAtRkvdG7boLeJ77/jVS3I/ERP5OJsd4tZO23SxYRE0oMfSrK
	mwjABGG6RMHClHBenSebONwLu8pAfL37Jtpz18XimeVahqWa5npRyeHNxS/HfH6/EWMl87
	sFh/5zfz662TIszGDMKAOMhP3FwJa2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717399374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5QpIqfLnJmZAO1whz9lIXGN+ri4N7A336dW2TxOKdI=;
	b=TpIhuXrQOjYUWJupSGP8NFbzhMTAqEJHxeuoho8wDaXBGNRMRg0aQCWNUN58mKgF2CkxjV
	RBrq57FI9mOzx2AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717399374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5QpIqfLnJmZAO1whz9lIXGN+ri4N7A336dW2TxOKdI=;
	b=HxLZlnwBB2TkzeR8grhT0rAtRkvdG7boLeJ77/jVS3I/ERP5OJsd4tZO23SxYRE0oMfSrK
	mwjABGG6RMHClHBenSebONwLu8pAfL37Jtpz18XimeVahqWa5npRyeHNxS/HfH6/EWMl87
	sFh/5zfz662TIszGDMKAOMhP3FwJa2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717399374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5QpIqfLnJmZAO1whz9lIXGN+ri4N7A336dW2TxOKdI=;
	b=TpIhuXrQOjYUWJupSGP8NFbzhMTAqEJHxeuoho8wDaXBGNRMRg0aQCWNUN58mKgF2CkxjV
	RBrq57FI9mOzx2AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8AB0139CB;
	Mon,  3 Jun 2024 07:22:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PsJOKk1vXWa1VwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 07:22:53 +0000
Message-ID: <2be3230e-993a-46af-ad46-4da16c7a7d25@suse.de>
Date: Mon, 3 Jun 2024 09:22:53 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] nvme-tcp: use sendpages_ok() instead of sendpage_ok()
Content-Language: en-US
To: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me
References: <20240530132629.4180932-1-ofir.gal@volumez.com>
 <20240530132629.4180932-3-ofir.gal@volumez.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240530132629.4180932-3-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 5/30/24 15:26, Ofir Gal wrote:
> Currently nvme_tcp_try_send_data() use sendpage_ok() in order to disable
> MSG_SPLICE_PAGES, it check the first page of the iterator, the iterator
> may represent contiguous pages.
> 
> MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
> pages it sends with sendpage_ok().
> 
> When nvme_tcp_try_send_data() sends an iterator that the first page is
> sendable, but one of the other pages isn't skb_splice_from_iter() warns
> and aborts the data transfer.
> 
> Using the new helper sendpages_ok() in order to disable MSG_SPLICE_PAGES
> solves the issue.
> 
> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
> ---
>   drivers/nvme/host/tcp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index 8b5e4327fe83..9f0fd14cbcb7 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -1051,7 +1051,7 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
>   		else
>   			msg.msg_flags |= MSG_MORE;
>   
> -		if (!sendpage_ok(page))
> +		if (!sendpages_ok(page, len, offset))
>   			msg.msg_flags &= ~MSG_SPLICE_PAGES;
>   
>   		bvec_set_page(&bvec, page, len, offset);
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


