Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822BC447E08
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 11:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbhKHKd2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 05:33:28 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:38812 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237988AbhKHKd1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 05:33:27 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B90301FD72;
        Mon,  8 Nov 2021 10:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636367442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iDx/7CZzaNjjmDk2+R38qaxkMccCMaHTReVGhyqWZSE=;
        b=ygSpyIPEsiLhF8WUcTaA/aYmJaD63/CAoA5F1HiPHBnDDqcxg68Ea39urJXTWTRXaxGv47
        fednNjw3krfvEODDYrfY83JYNb3q19yLeIQTuAez8MWeEDY2P+unj27KGtJGFBBGreHVB3
        967sbirQyToTGX868zg8S6nLnWjAUjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636367442;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iDx/7CZzaNjjmDk2+R38qaxkMccCMaHTReVGhyqWZSE=;
        b=in7NEiKJYqEvgU59TNgkTd65gEkWZMNUJpRxLZHzEyeSC1SEyw6ev/cde3plRRwkd4GVcX
        +QD1VkQsdqOPolBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C1CF13B37;
        Mon,  8 Nov 2021 10:30:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 24zIC1L8iGESHwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 08 Nov 2021 10:30:42 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 1495a6f8;
        Mon, 8 Nov 2021 10:30:41 +0000 (UTC)
Date:   Mon, 8 Nov 2021 10:30:41 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ceph: libceph: move ceph_osdc_copy_from() into
 cephfs code
Message-ID: <YYj8UQFLHTI0WwGg@suse.de>
References: <20211104123147.1632-1-lhenriques@suse.de>
 <20211104123147.1632-2-lhenriques@suse.de>
 <CAOi1vP8QYm+JR7c2_t5uSk-8jmqTmRs4WNYhDAoYfgar2cPw4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP8QYm+JR7c2_t5uSk-8jmqTmRs4WNYhDAoYfgar2cPw4Q@mail.gmail.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya,

On Mon, Nov 08, 2021 at 04:46:40AM +0100, Ilya Dryomov wrote:
> On Thu, Nov 4, 2021 at 1:31 PM Luís Henriques <lhenriques@suse.de> wrote:
> >
> > This patch moves ceph_osdc_copy_from() function out of libceph code into
> > cephfs.  There are no other users for this function, and there is the need
> > (in another patch) to access internal ceph_osd_request struct members.
> > Thus, instead of changing ceph_osdc_copy_from() to return the request,
> > simply move it where it is needed.
> 
> Hi Luis,
> 
> ceph_alloc_copyfrom_request() does exactly that -- returns the request.
> I have dropped this sentence from the changelog but wanted to check if
> you meant to keep the change instead of just moving and renaming.

Dropping that sentence seems the right thing to do.  I've just checked the
'testing' branch and the changelog looks good to me.  Thanks!

Cheers,
--
Luís
