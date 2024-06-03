Return-Path: <ceph-devel+bounces-1252-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E70A58D7E20
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 11:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15FD71C22658
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 09:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD007E574;
	Mon,  3 Jun 2024 09:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EFaWHWyD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xcyh93yc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EFaWHWyD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xcyh93yc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDA858AA5;
	Mon,  3 Jun 2024 09:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717405681; cv=none; b=K95ojbmNd3jUf3T6DfSxxvCr8i8Rk0THaAFH9yZSZPOb6ZSERX3XwLVRYwSCTWJ9vmFi5gxbJYC1FU0DRjmy8fbgcz/YNRsq/DmYO76SdHvrm7OsMp3WgwMfy7+hKbm7HW/h2V/UhKDPw1txgdgyIFu/zYj2C2affHydvOON1tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717405681; c=relaxed/simple;
	bh=o8og3+X4kAotptjOeJvzbMa6J6OO6A366JB7jJKqXuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dP5S8MEU9VkhwkOW4VTC2KXB+6WdzK6KOUJtKjPg8Mgzlioby1wPRXpOqG3+LLYOwefy4Gs8B85ixL/GGzTYwpBRWWXfFqUC/JvOf1GpF9wvMZq5FjPItil+dfaVvDn+IKQcr5lL7B/GKGXKAItMuJ/JuFzj49XdUK6kcJ3O/dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EFaWHWyD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xcyh93yc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EFaWHWyD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xcyh93yc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 06AF420010;
	Mon,  3 Jun 2024 09:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717405678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eSDgE8l46R7RpNxPmAdHDdwYh7tkrvI5HLTyxSYp75U=;
	b=EFaWHWyDM1b5NdDa9MadJ0vfSn36GBj93Cdo8NnNX8E9eQTf6WtvWeEp41mvs3XVDOSUGi
	4UBndJfX+eQjWfvhwcbhHy1tL7t6i50sMXcm1aFG0COO/5WuSOuDiUVkGhIWAKlh927lod
	refa9WP2WjR2scL28HAYg6wgC70Aigw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717405678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eSDgE8l46R7RpNxPmAdHDdwYh7tkrvI5HLTyxSYp75U=;
	b=Xcyh93ycKFGruh6MNLpCiNc/sPEjWrMG706NVPeNbLQVVxyTyY5LY7MiNck61gKko8W4bu
	SNHTdMnprM4QlMAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717405678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eSDgE8l46R7RpNxPmAdHDdwYh7tkrvI5HLTyxSYp75U=;
	b=EFaWHWyDM1b5NdDa9MadJ0vfSn36GBj93Cdo8NnNX8E9eQTf6WtvWeEp41mvs3XVDOSUGi
	4UBndJfX+eQjWfvhwcbhHy1tL7t6i50sMXcm1aFG0COO/5WuSOuDiUVkGhIWAKlh927lod
	refa9WP2WjR2scL28HAYg6wgC70Aigw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717405678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eSDgE8l46R7RpNxPmAdHDdwYh7tkrvI5HLTyxSYp75U=;
	b=Xcyh93ycKFGruh6MNLpCiNc/sPEjWrMG706NVPeNbLQVVxyTyY5LY7MiNck61gKko8W4bu
	SNHTdMnprM4QlMAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76FE213A93;
	Mon,  3 Jun 2024 09:07:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IgRyHO2HXWY4egAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 09:07:57 +0000
Message-ID: <05d5fd1a-9295-4753-a201-c9a968ee7982@suse.de>
Date: Mon, 3 Jun 2024 11:07:57 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
To: Jakub Kicinski <kuba@kernel.org>, Ofir Gal <ofir.gal@volumez.com>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
 ceph-devel@vger.kernel.org, dhowells@redhat.com, edumazet@google.com,
 pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
 <20240601153430.19416989@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240601153430.19416989@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-3.96 / 50.00];
	BAYES_HAM(-2.67)[98.56%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[davemloft.net,vger.kernel.org,lists.infradead.org,redhat.com,google.com,kernel.org,kernel.dk,lst.de,grimberg.me,linbit.com,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -3.96
X-Spam-Flag: NO

On 6/2/24 00:34, Jakub Kicinski wrote:
> On Thu, 30 May 2024 17:24:10 +0300 Ofir Gal wrote:
>> skbuff: before sendpage_ok - i: 0. page: 0x654eccd7 (pfn: 120755)
>> skbuff: before sendpage_ok - i: 1. page: 0x1666a4da (pfn: 120756)
>> skbuff: before sendpage_ok - i: 2. page: 0x54f9f140 (pfn: 120757)
> 
> noob question, how do you get 3 contiguous pages, the third of which
> is slab? is_slab doesn't mean what I think it does, or we got extremely
> lucky with kmalloc?
> 
I guess it's not slab which triggered; the actual code is:

static inline bool sendpage_ok(struct page *page)
{
         return !PageSlab(page) && page_count(page) >= 1;
}

My bet is on 'page_count()' triggering.

Cheers,

Hannes


