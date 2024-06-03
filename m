Return-Path: <ceph-devel+bounces-1251-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C352F8D7C67
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 09:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6A3DB20812
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2024 07:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1493E43ADC;
	Mon,  3 Jun 2024 07:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sugloF5m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CTY+7Gjc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sugloF5m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CTY+7Gjc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DD94084D;
	Mon,  3 Jun 2024 07:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717399465; cv=none; b=B9Y8qhyrz5MkglBdbx+vLIYUeqiLFzwcZWSS+Dv7hioVqgiZc4s7oeTfFKyXl77wQhSr9xLBSgrT6sxfX2MrrO0ll+4g4E098G0pivnNIia+9DwRkVVjaMnaJucYEW6aBRbG7wwQ/kQFD4q1I9rppPg01XlZFpOdMoooDA6sv2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717399465; c=relaxed/simple;
	bh=YiCCRRJhyD33JfIXlEzxcBZGbVAZ9WJCNb8kPOGTv68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ITJONLvzo1fvJL4LNpG0J1rNukKQEcDUeZDynLFO5NxYLN2S315esN/pLCwARYSFiJWAe09f8/MPLjjUlevKlY6n9bjfVkCZlb9VAph2gvmGWDZaUDAlg5frxBxIHc6w1cvXFDsxPrvwXEMb6VTjXbCtFYQZIeUStz8StJ+wuw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sugloF5m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CTY+7Gjc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sugloF5m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CTY+7Gjc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0DF0322022;
	Mon,  3 Jun 2024 07:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717399462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a2bJzNeQZky846Z95Ej0BchOIVdohOw0oxASksp4Yl8=;
	b=sugloF5mBdeWecoYHgF8TGh7vlr1CEtoloFQYrjNC/OlNvSVvT+WgJT5BP0O+2Vnqtxrw6
	lvaxWXtOfFOZjlWRqLoyUgjQusz2PtOmv0Ik8zoX/fRqe8yvIzsGyYTONFBDvW5PaBkMS+
	lmwkvTdVjyiIaOwV7noCvJ49cPOzNvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717399462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a2bJzNeQZky846Z95Ej0BchOIVdohOw0oxASksp4Yl8=;
	b=CTY+7GjceMZK2XjTs4KMn213TTSY0EbbTZlcUqarQ/NoclaH3EiRsJZkv+aoLa+EeOXWlW
	iI4C7u7KRGF5wUDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sugloF5m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CTY+7Gjc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717399462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a2bJzNeQZky846Z95Ej0BchOIVdohOw0oxASksp4Yl8=;
	b=sugloF5mBdeWecoYHgF8TGh7vlr1CEtoloFQYrjNC/OlNvSVvT+WgJT5BP0O+2Vnqtxrw6
	lvaxWXtOfFOZjlWRqLoyUgjQusz2PtOmv0Ik8zoX/fRqe8yvIzsGyYTONFBDvW5PaBkMS+
	lmwkvTdVjyiIaOwV7noCvJ49cPOzNvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717399462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a2bJzNeQZky846Z95Ej0BchOIVdohOw0oxASksp4Yl8=;
	b=CTY+7GjceMZK2XjTs4KMn213TTSY0EbbTZlcUqarQ/NoclaH3EiRsJZkv+aoLa+EeOXWlW
	iI4C7u7KRGF5wUDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D9C5139CB;
	Mon,  3 Jun 2024 07:24:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MEAvC6VvXWa1VwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 07:24:21 +0000
Message-ID: <a3fac93a-af2b-4969-8ab5-302089cdb3a6@suse.de>
Date: Mon, 3 Jun 2024 09:24:21 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
Content-Language: en-US
To: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
 kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
References: <20240530142417.146696-1-ofir.gal@volumez.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240530142417.146696-1-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0DF0322022
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,kernel.dk,lst.de,grimberg.me,linbit.com,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]

On 5/30/24 16:24, Ofir Gal wrote:
> skb_splice_from_iter() warns on !sendpage_ok() which results in nvme-tcp
> data transfer failure. This warning leads to hanging IO.
> 
> nvme-tcp using sendpage_ok() to check the first page of an iterator in
> order to disable MSG_SPLICE_PAGES. The iterator can represent a list of
> contiguous pages.
> 
> When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
> it requires all pages in the iterator to be sendable.
> skb_splice_from_iter() checks each page with sendpage_ok().
> 
> nvme_tcp_try_send_data() might allow MSG_SPLICE_PAGES when the first
> page is sendable, but the next one are not. skb_splice_from_iter() will
> attempt to send all the pages in the iterator. When reaching an
> unsendable page the IO will hang.
> 
> The patch introduces a helper sendpages_ok(), it returns true if all the
> continuous pages are sendable.
> 
> Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
> this helper to check whether the page list is OK. If the helper does not
> return true, the driver should remove MSG_SPLICE_PAGES flag.
> 
> 
> The bug is reproducible, in order to reproduce we need nvme-over-tcp
> controllers with optimal IO size bigger than PAGE_SIZE. Creating a raid
> with bitmap over those devices reproduces the bug.
> 
> In order to simulate large optimal IO size you can use dm-stripe with a
> single device.
> Script to reproduce the issue on top of brd devices using dm-stripe is
> attached below.
> 
> 
> I have added 3 prints to test my theory. One in nvme_tcp_try_send_data()
> and two others in skb_splice_from_iter() the first before sendpage_ok()
> and the second on !sendpage_ok(), after the warning.
> ...
> nvme_tcp: sendpage_ok, page: 0x654eccd7 (pfn: 120755), len: 262144, offset: 0
> skbuff: before sendpage_ok - i: 0. page: 0x654eccd7 (pfn: 120755)
> skbuff: before sendpage_ok - i: 1. page: 0x1666a4da (pfn: 120756)
> skbuff: before sendpage_ok - i: 2. page: 0x54f9f140 (pfn: 120757)
> WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x142/0x450
> skbuff: !sendpage_ok - page: 0x54f9f140 (pfn: 120757). is_slab: 1, page_count: 1
> ...
> 
> 
> stack trace:
> ...
> WARNING: at net/core/skbuff.c:6848 skb_splice_from_iter+0x141/0x450
> Workqueue: nvme_tcp_wq nvme_tcp_io_work
> Call Trace:
>   ? show_regs+0x6a/0x80
>   ? skb_splice_from_iter+0x141/0x450
>   ? __warn+0x8d/0x130
>   ? skb_splice_from_iter+0x141/0x450
>   ? report_bug+0x18c/0x1a0
>   ? handle_bug+0x40/0x70
>   ? exc_invalid_op+0x19/0x70
>   ? asm_exc_invalid_op+0x1b/0x20
>   ? skb_splice_from_iter+0x141/0x450
>   tcp_sendmsg_locked+0x39e/0xee0
>   ? _prb_read_valid+0x216/0x290
>   tcp_sendmsg+0x2d/0x50
>   inet_sendmsg+0x43/0x80
>   sock_sendmsg+0x102/0x130
>   ? vprintk_default+0x1d/0x30
>   ? vprintk+0x3c/0x70
>   ? _printk+0x58/0x80
>   nvme_tcp_try_send_data+0x17d/0x530
>   nvme_tcp_try_send+0x1b7/0x300
>   nvme_tcp_io_work+0x3c/0xc0
>   process_one_work+0x22e/0x420
>   worker_thread+0x50/0x3f0
>   ? __pfx_worker_thread+0x10/0x10
>   kthread+0xd6/0x100
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork+0x3c/0x60
>   ? __pfx_kthread+0x10/0x10
>   ret_from_fork_asm+0x1b/0x30
> ...
> 
> ---
> Changelog:
> v2, fix typo in patch subject
> 
> Ofir Gal (4):
>    net: introduce helper sendpages_ok()
>    nvme-tcp: use sendpages_ok() instead of sendpage_ok()
>    drbd: use sendpages_ok() to instead of sendpage_ok()
>    libceph: use sendpages_ok() to instead of sendpage_ok()
> 
>   drivers/block/drbd/drbd_main.c |  2 +-
>   drivers/nvme/host/tcp.c        |  2 +-
>   include/linux/net.h            | 20 ++++++++++++++++++++
>   net/ceph/messenger_v1.c        |  2 +-
>   net/ceph/messenger_v2.c        |  2 +-
>   5 files changed, 24 insertions(+), 4 deletions(-)
> 
>   reproduce.sh | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 114 insertions(+)
>   create mode 100755 reproduce.sh
> 
> diff --git a/reproduce.sh b/reproduce.sh
> new file mode 100755
> index 000000000..8ae226b18
> --- /dev/null
> +++ b/reproduce.sh
> @@ -0,0 +1,114 @@
> +#!/usr/bin/env sh
> +# SPDX-License-Identifier: MIT
> +
> +set -e
> +
> +load_modules() {
> +    modprobe nvme
> +    modprobe nvme-tcp
> +    modprobe nvmet
> +    modprobe nvmet-tcp
> +}
> +
> +setup_ns() {
> +    local dev=$1
> +    local num=$2
> +    local port=$3
> +    ls $dev > /dev/null
> +
> +    mkdir -p /sys/kernel/config/nvmet/subsystems/$num
> +    cd /sys/kernel/config/nvmet/subsystems/$num
> +    echo 1 > attr_allow_any_host
> +
> +    mkdir -p namespaces/$num
> +    cd namespaces/$num/
> +    echo $dev > device_path
> +    echo 1 > enable
> +
> +    ln -s /sys/kernel/config/nvmet/subsystems/$num \
> +        /sys/kernel/config/nvmet/ports/$port/subsystems/
> +}
> +
> +setup_port() {
> +    local num=$1
> +
> +    mkdir -p /sys/kernel/config/nvmet/ports/$num
> +    cd /sys/kernel/config/nvmet/ports/$num
> +    echo "127.0.0.1" > addr_traddr
> +    echo tcp > addr_trtype
> +    echo 8009 > addr_trsvcid
> +    echo ipv4 > addr_adrfam
> +}
> +
> +setup_big_opt_io() {
> +    local dev=$1
> +    local name=$2
> +
> +    # Change optimal IO size by creating dm stripe
> +    dmsetup create $name --table \
> +        "0 `blockdev --getsz $dev` striped 1 512 $dev 0"
> +}
> +
> +setup_targets() {
> +    # Setup ram devices instead of using real nvme devices
> +    modprobe brd rd_size=1048576 rd_nr=2 # 1GiB
> +
> +    setup_big_opt_io /dev/ram0 ram0_big_opt_io
> +    setup_big_opt_io /dev/ram1 ram1_big_opt_io
> +
> +    setup_port 1
> +    setup_ns /dev/mapper/ram0_big_opt_io 1 1
> +    setup_ns /dev/mapper/ram1_big_opt_io 2 1
> +}
> +
> +setup_initiators() {
> +    nvme connect -t tcp -n 1 -a 127.0.0.1 -s 8009
> +    nvme connect -t tcp -n 2 -a 127.0.0.1 -s 8009
> +}
> +
> +reproduce_warn() {
> +    local devs=$@
> +
> +    # Hangs here
> +    mdadm --create /dev/md/test_md --level=1 --bitmap=internal \
> +        --bitmap-chunk=1024K --assume-clean --run --raid-devices=2 $devs
> +}
> +
> +echo "###################################
> +
> +The script creates 2 nvme initiators in order to reproduce the bug.
> +The script doesn't know which controllers it created, choose the new nvme
> +controllers when asked.
> +
> +###################################
> +
> +Press enter to continue.
> +"
> +
> +read tmp
> +
> +echo "# Creating 2 nvme controllers for the reproduction. current nvme devices:"
> +lsblk -s | grep nvme || true
> +echo "---------------------------------
> +"
> +
> +load_modules
> +setup_targets
> +setup_initiators
> +
> +sleep 0.1 # Wait for the new nvme ctrls to show up
> +
> +echo "# Created 2 nvme devices. nvme devices list:"
> +
> +lsblk -s | grep nvme
> +echo "---------------------------------
> +"
> +
> +echo "# Insert the new nvme devices as separated lines. both should be with size of 1G"
> +read dev1
> +read dev2
> +
> +ls /dev/$dev1 > /dev/null
> +ls /dev/$dev2 > /dev/null
> +
> +reproduce_warn /dev/$dev1 /dev/$dev2

Can you convert that into a blktest script?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


