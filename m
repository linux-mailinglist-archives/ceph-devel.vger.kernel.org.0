Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5B653E0D1
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 08:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiFFF3D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 01:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiFFF2n (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 01:28:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B5EF4339D
        for <ceph-devel@vger.kernel.org>; Sun,  5 Jun 2022 22:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654492634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=weYEkQxQGDB1VH3hIGPrCtqI/pW5vKqfuvLKjvItR/Y=;
        b=M9TlfVuKIPo9juqGOXxm4caHTdlELLzpqQGrNC+07VJSVSIMPK+ClFOMdfWYVI1JDFLjj5
        qF8o7CxV8k14EG5Fu7yNeVYLJhOo4K3L0M2AjiD2R4m0q7YM/q5lrNSeDR3NmMvpO8AYr2
        TDNTdW+SXybFl03WZn0na9O/EVxXFfU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-Mmo54ZN0PKCosdKGspmpBQ-1; Mon, 06 Jun 2022 01:17:12 -0400
X-MC-Unique: Mmo54ZN0PKCosdKGspmpBQ-1
Received: by mail-pg1-f200.google.com with SMTP id e18-20020a656492000000b003fa4033f9a7so6440453pgv.17
        for <ceph-devel@vger.kernel.org>; Sun, 05 Jun 2022 22:17:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=weYEkQxQGDB1VH3hIGPrCtqI/pW5vKqfuvLKjvItR/Y=;
        b=6ZHdQUTeyMG1ERMlT+BE6GeYzOrACX9TGg95lZXKkJgPNwzkqu5OGq9+ZE0Va70QWW
         gev+jo1zjdA4OXDt34w05FJwCPLdQw3cJFZFmp2vQxLBTfkVogttwkUW86aycAaJ76m6
         oFHRdl2roif8hBquYfFSG5nLIc2euvnAvazAHVaBWvDTgdo/XA8ITvR7KgErHz97o7C1
         qH/jXF+Jlqeygi64KWSqWdH4YDAHurfwznUFkfM0+FXOzO+ima3kgCZo20IYqZ6Bj7+/
         469Pw/S7G3xmv6+PbYFI8gPX+GkiEOknupK0RE3X/xsj1TffH+bAAtJTxa+/DShWfOx6
         kEFg==
X-Gm-Message-State: AOAM531C1oU8mpxsQx0WAS7QontYA9yy5zeiSkiU5r5SvhmPN/b6BLPr
        wEutrREfQi0xhYis1rCJpHiScf6eTR/1Rd6pqVvKstBPvOQUWsb4B3jBViq4QSrRrOdRelmg3NM
        lSYGx7wz22HONqzW023y2RKQNugw5iGltOeO+bwY1a5R2solFdQZTm5yVWDlGC2HrxYwAdjw=
X-Received: by 2002:a65:5c48:0:b0:382:2c7:28e9 with SMTP id v8-20020a655c48000000b0038202c728e9mr20138561pgr.472.1654492631316;
        Sun, 05 Jun 2022 22:17:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXAXRj9ZOckWTEJ+b/N2vzTUML74e1IGLrmyYvdW7W2i/x5bcyzX+CXlUXPQ7HJkNvT0bsRQ==
X-Received: by 2002:a65:5c48:0:b0:382:2c7:28e9 with SMTP id v8-20020a655c48000000b0038202c728e9mr20138541pgr.472.1654492630931;
        Sun, 05 Jun 2022 22:17:10 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3-20020a056a0002a300b0051be16492basm5647824pfs.195.2022.06.05.22.17.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jun 2022 22:17:10 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't leak snap_rwsem in handle_cap_grant
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220603203957.55337-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4aa4ce81-4a49-7e0a-ede7-204149d1c9ca@redhat.com>
Date:   Mon, 6 Jun 2022 13:17:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220603203957.55337-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/4/22 4:39 AM, Jeff Layton wrote:
> When handle_cap_grant is called on an IMPORT op, then the snap_rwsem is
> held and the function is expected to release it before returning. It
> currently fails to do that in all cases which could lead to a deadlock.
>
> URL: https://tracker.ceph.com/issues/55857
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c | 27 +++++++++++++--------------
>   1 file changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 258093e9074d..0a48bf829671 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3579,24 +3579,23 @@ static void handle_cap_grant(struct inode *inode,
>   			fill_inline = true;
>   	}
>   
> -	if (ci->i_auth_cap == cap &&
> -	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> -		if (newcaps & ~extra_info->issued)
> -			wake = true;
> +	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> +		if (ci->i_auth_cap == cap) {
> +			if (newcaps & ~extra_info->issued)
> +				wake = true;
> +
> +			if (ci->i_requested_max_size > max_size ||
> +			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> +				/* re-request max_size if necessary */
> +				ci->i_requested_max_size = 0;
> +				wake = true;
> +			}
>   
> -		if (ci->i_requested_max_size > max_size ||
> -		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> -			/* re-request max_size if necessary */
> -			ci->i_requested_max_size = 0;
> -			wake = true;
> +			ceph_kick_flushing_inode_caps(session, ci);
>   		}
> -
> -		ceph_kick_flushing_inode_caps(session, ci);
> -		spin_unlock(&ci->i_ceph_lock);
>   		up_read(&session->s_mdsc->snap_rwsem);
> -	} else {
> -		spin_unlock(&ci->i_ceph_lock);
>   	}
> +	spin_unlock(&ci->i_ceph_lock);
>   
>   	if (fill_inline)
>   		ceph_fill_inline_data(inode, NULL, extra_info->inline_data,

I am not sure what the following code in Line#4139 wants to do, more 
detail please see [1].

4131         if (msg_version >= 3) {
4132                 if (op == CEPH_CAP_OP_IMPORT) {
4133                         if (p + sizeof(*peer) > end)
4134                                 goto bad;
4135                         peer = p;
4136                         p += sizeof(*peer);
4137                 } else if (op == CEPH_CAP_OP_EXPORT) {
4138                         /* recorded in unused fields */
4139                         peer = (void *)&h->size;
4140 }
4141         }

For the export case the members in the 'peer' are always assigned to 
'random' values. And seems could cause this issue.

[1] https://github.com/ceph/ceph-client/blob/for-linus/fs/ceph/caps.c#L4134

I am still reading the code. Any idea ?

-- Xiubo


