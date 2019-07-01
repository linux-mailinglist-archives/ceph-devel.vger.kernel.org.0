Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD175B96D
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 12:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfGAKvD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 06:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbfGAKvD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 06:51:03 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E34D208E4;
        Mon,  1 Jul 2019 10:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561978262;
        bh=5PdjtRCz3MsCL9jpt/BRvTdKe0qd1i+CjPmHWuZmins=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dXqItWwRybLvXdgzugLI0yRdsD4hLBmpPOzGnvy6t0AiwG08WKv+GAtZ0vGh9d0Hz
         sjyyOuLx6sQLQCZfn6H6mgB10Fr1MOQn0Eu9JvCcRMo7/sRw7mEITiEWfzrF/McVar
         fZHKPzB7B/CuUaB9bWwbbslaWJJ/m5jTUjSO1Ws0=
Message-ID: <9dc2dff0cf07b41cb9ba52e4846e4d783ac39b91.camel@kernel.org>
Subject: Re: [PATCH 15/20] libceph: bump CEPH_MSG_MAX_DATA_LEN (again)
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Date:   Mon, 01 Jul 2019 06:51:00 -0400
In-Reply-To: <20190625144111.11270-16-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
         <20190625144111.11270-16-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-06-25 at 16:41 +0200, Ilya Dryomov wrote:
> This time for rbd object map.  Object maps are limited in size to
> 256000000 objects, two bits per object.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  include/linux/ceph/libceph.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 337d5049ff93..0ae60b55e55a 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -84,11 +84,13 @@ struct ceph_options {
>  #define CEPH_MSG_MAX_MIDDLE_LEN	(16*1024*1024)
>  
>  /*
> - * Handle the largest possible rbd object in one message.
> + * The largest possible rbd data object is 32M.
> + * The largest possible rbd object map object is 64M.
> + *
>   * There is no limit on the size of cephfs objects, but it has to obey
>   * rsize and wsize mount options anyway.
>   */
> -#define CEPH_MSG_MAX_DATA_LEN	(32*1024*1024)
> +#define CEPH_MSG_MAX_DATA_LEN	(64*1024*1024)
>  
>  #define CEPH_AUTH_NAME_DEFAULT   "guest"
>  

Does this value serve any real purpose? I know we use this to cap cephfs
rsize/wsize values, but other than that, it's only used in
read_partial_message:

        data_len = le32_to_cpu(con->in_hdr.data_len);
        if (data_len > CEPH_MSG_MAX_DATA_LEN)
                return -EIO;

I guess this is supposed to be some sort of sanity check, but it seems a
bit arbitrary, and something that ought to be handled more naturally by
other limits later in the code.
-- 
Jeff Layton <jlayton@kernel.org>

