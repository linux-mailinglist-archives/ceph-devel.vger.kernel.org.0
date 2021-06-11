Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F0F3A45CE
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 17:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFKQAl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 12:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhFKQAk (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 12:00:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA793613EA;
        Fri, 11 Jun 2021 15:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623427122;
        bh=jt6qB2Ao+A1MOTgr8UpYdyTOj6DYjEQGDUj5dIiuvqg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lkasTjjBAXJGtAIZ3gThuRk2Fe2Jbi1VACM/lvi/RjiWk3pjOK+YbZH68JriFysVU
         SouIeCv0UtgMW7oDN7tUNYHQW98GkPj7i830cN/a7cXAL+M0AC3REDE2Q+m98ktjnV
         GTcP/Rs+WelkYX3Jd60VCbgNLW5s9saABtmj0/qXGc8pVhKO5rywXReNkPbk2v/WaW
         yz36HRl7Wzp5Kt2AA6dvhRPPeWTm/Z5GGgzgHG67sWWVci4iVDaXZpv07YdNgwzH82
         lE0GwSWpxUjEFZCPM3cSQdX28HcUsM1SdbMhG7DW/uN+7loMC1wydnLSgVCV3myz7R
         12w0UkYUsJ0gQ==
Message-ID: <44c35af5cc83b5c01fd55c7be6c0c16dd03cea2b.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: fix write_begin optimization when write is
 beyond EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, pfmeec@rit.edu, willy@infradead.org,
        dhowells@redhat.com, Andrew W Elble <aweits@rit.edu>
Date:   Fri, 11 Jun 2021 11:58:40 -0400
In-Reply-To: <20210611155509.76691-1-jlayton@kernel.org>
References: <20210611155509.76691-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-06-11 at 11:55 -0400, Jeff Layton wrote:
> It's not sufficient to skip reading when the pos is beyond the EOF.
> There may be data at the head of the page that we need to fill in
> before the write. Only elide the read if the pos is beyond the last page
> in the file.
> 
> Reported-by: Andrew W Elble <aweits@rit.edu>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> I've not tested this at all yet, but I think this is probably what we'll
> want for stable series v5.10.z - v5.12.z.
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 35c83f65475b..9f60f541b423 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1353,11 +1353,11 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
>  		/*
>  		 * In some cases we don't need to read at all:
>  		 * - full page write
> -		 * - write that lies completely beyond EOF
> +		 * - write that lies in a page that is completely beyond EOF
>  		 * - write that covers the the page from start to EOF or beyond it
>  		 */
>  		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
> -		    (pos >= i_size_read(inode)) ||
> +		    (index >= (i_size_read(inode) << PAGE_SHIFT)) ||

...and this should be:

		(index > (i_size_read(inode) << PAGE_SHIFT)) ||
			
We only get to skip the read if the write pos is _beyond_ the last page.

>  		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
>  			zero_user_segments(page, 0, pos_in_page,
>  					   pos_in_page + len, PAGE_SIZE);

-- 
Jeff Layton <jlayton@kernel.org>

