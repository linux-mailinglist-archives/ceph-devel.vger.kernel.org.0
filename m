Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70B52D2B25
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 13:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgLHMez (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 07:34:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728287AbgLHMez (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 07:34:55 -0500
Message-ID: <58d2f1c5a9ce13f8aecda76604cca35c5165c66d.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607430855;
        bh=Er5xcsNPsz3otM9/RXcwk6ynK4/AERkuOk9oTRHck3k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FK/FecMZZv2Bn9AbLyqFn7InIaqKyIFArfgNCe9p2Pb9Izj4gOV3KOE+m5YDui9Wn
         iI0sza3la/vkt99/jE9Z8Za34FnYLTHcy/x5xGLqMSIVaOvfi5+GbelqmuYw33kqZx
         5K1GkiWndNjPtwN4wTs+8PAVnq/u8yEhoxZfXYQLMWqCuxm67MMLjGO7h0jLLB93Oj
         7NB9tlj61ujUO3xi/8g9iIU6lmK+oQNyd+MW6qNniHyQJBani8ZYGcDg6eiAvxdoxY
         jcYN6MnqXm4nvCrg77FdxvbJJtziUublJVtR9PQ7bvyXQo89Qc3hZR7tPmNRyptKqc
         uPXo4Stb6LkBg==
Subject: Re: [PATCH] ceph: remove redundant assignment to variable i
From:   Jeff Layton <jlayton@kernel.org>
To:     Colin King <colin.king@canonical.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 08 Dec 2020 07:34:13 -0500
In-Reply-To: <20201204185421.1149669-1-colin.king@canonical.com>
References: <20201204185421.1149669-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-12-04 at 18:54 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable i is being initialized with a value that is never read
> and it is being updated later with a new value in a for-loop.  The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/ceph/mds_client.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 8f1d7500a7ec..b70937caa7a7 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1243,7 +1243,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>  {
>  	struct ceph_msg *msg;
>  	struct ceph_mds_session_head *h;
> -	int i = -1;
> +	int i;
>  	int extra_bytes = 0;
>  	int metadata_key_count = 0;
>  	struct ceph_options *opt = mdsc->fsc->client->options;

Meh, ok. Merged into ceph-client/testing branch. It should make v5.11.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

