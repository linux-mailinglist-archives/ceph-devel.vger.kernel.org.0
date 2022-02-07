Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4044ABFDD
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 14:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358103AbiBGNox (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 08:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386976AbiBGNRQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 08:17:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87226C0401DE
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 05:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644239821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5b9YB1LucKdQ8z+iasQgelRq9dbhUULbU2amePcHtr0=;
        b=OgZgyRImlBoENqs5qklPzOZMgUBfQ7eKmye9u3yLxX0KgyRiXsMim5DHiegDxkzjhU2suw
        BmoJatJXBIgYh21ArYKjS++EDQAqa7Zi7jIuF3O9xNKuuH6smNvUU70EdxgTJxkU+JmVeq
        k0RmtmVHuiw5dFKZy8F1pbkZhiK1CSM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-LNHW95urPKeLHty9EcNn7Q-1; Mon, 07 Feb 2022 08:17:00 -0500
X-MC-Unique: LNHW95urPKeLHty9EcNn7Q-1
Received: by mail-pj1-f69.google.com with SMTP id bj11-20020a17090b088b00b001b8ba3e7ce7so2711981pjb.2
        for <ceph-devel@vger.kernel.org>; Mon, 07 Feb 2022 05:17:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5b9YB1LucKdQ8z+iasQgelRq9dbhUULbU2amePcHtr0=;
        b=U+NdHGJ9aYl9Z+oAHsvGyOHlI3pX/S6txd6c3rQ2jU+eYiUAqtH4xe+EI8zYLXR2IV
         jwU9q458QdG0jNsnVwIuf2CF4zZ58V4+ypQzy8gYWuBW82RnGNA83S/tFCczg8OnLKVU
         Sg/xwZPiIJXxl6zO3oOTjAalyog+vqvYlay79TJPk9wsPb0utECDJtOCzCPRT6OhV5yC
         q9A7qFE2r5Lw4j92cAx/L1gnAi9Rekkeq3aZ4DOQ32kIrIQPdhEN7U0TeqXsah4MVxi/
         vVzMXMHIDd6T/hk7CpzzlwzaQjXvrisnpNQHYOyc/ngmacCDqVQwxbQ5t/QSDF6Cx4YN
         Qtxg==
X-Gm-Message-State: AOAM531GMfIKg9I8Q09H0/3qVqAXEk649ZW5HxU+3c4yWXjsJcw3/7Ud
        B3EeftrpFEuC52X8Hj4tirR2gNHRMzSt+e7X7k80LJbBpKZyP6TqN97xi0w+UFiuE3DqbtfyqY6
        hZZ/mq4QqzbnV0l/8O9/7H3iLWMMnJhns8LNv5LhcI8CU42l9J6C8wEMCmFVFfd63yEDAEh8=
X-Received: by 2002:a17:902:b493:: with SMTP id y19mr15942719plr.97.1644239818764;
        Mon, 07 Feb 2022 05:16:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJQCmodgvC5U+4ynBT+oN+twFuwQoApWm6lNYOrIWMVljtPjp1yoYNoiMBcXyORzaVRtdy8g==
X-Received: by 2002:a17:902:b493:: with SMTP id y19mr15942692plr.97.1644239818369;
        Mon, 07 Feb 2022 05:16:58 -0800 (PST)
Received: from [10.72.12.64] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b4sm12182539pfv.188.2022.02.07.05.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 05:16:58 -0800 (PST)
Subject: Re: [PATCH] ceph: wait for async create reply before sending any cap
 messages
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20220205151705.36309-1-jlayton@kernel.org>
 <60e4e14e-687b-7f8a-8dc9-548bd41619a4@redhat.com>
 <199f8e951498f261174d8c9656b6feafdcded7ad.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6db9c335-85f6-e299-b87f-9d0c5091ee4a@redhat.com>
Date:   Mon, 7 Feb 2022 21:16:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <199f8e951498f261174d8c9656b6feafdcded7ad.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/7/22 9:08 PM, Jeff Layton wrote:
> On Mon, 2022-02-07 at 14:54 +0800, Xiubo Li wrote:
>> On 2/5/22 11:17 PM, Jeff Layton wrote:
>>> If we haven't received a reply to an async create request, then we don't
>>> want to send any cap messages to the MDS for that inode yet.
>>>
>>> Just have ceph_check_caps  and __kick_flushing_caps return without doing
>>> anything, and have ceph_write_inode wait for the reply if we were asked
>>> to wait on the inode writeback.
>>>
>>> URL: https://tracker.ceph.com/issues/54107
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>    fs/ceph/caps.c | 14 ++++++++++++++
>>>    1 file changed, 14 insertions(+)
>>>
>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>> index e668cdb9c99e..f29e2dbcf8df 100644
>>> --- a/fs/ceph/caps.c
>>> +++ b/fs/ceph/caps.c
>>> @@ -1916,6 +1916,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>>>    		ceph_get_mds_session(session);
>>>    
>>>    	spin_lock(&ci->i_ceph_lock);
>>> +	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
>>> +		/* Don't send messages until we get async create reply */
>>> +		spin_unlock(&ci->i_ceph_lock);
>>> +		ceph_put_mds_session(session);
>>> +		return;
>>> +	}
>>> +
>>>    	if (ci->i_ceph_flags & CEPH_I_FLUSH)
>>>    		flags |= CHECK_CAPS_FLUSH;
>>>    retry:
>>> @@ -2410,6 +2417,9 @@ int ceph_write_inode(struct inode *inode, struct writeback_control *wbc)
>>>    	dout("write_inode %p wait=%d\n", inode, wait);
>>>    	ceph_fscache_unpin_writeback(inode, wbc);
>>>    	if (wait) {
>>> +		err = ceph_wait_on_async_create(inode);
>>> +		if (err)
>>> +			return err;
>>>    		dirty = try_flush_caps(inode, &flush_tid);
>>>    		if (dirty)
>>>    			err = wait_event_interruptible(ci->i_cap_wq,
>>> @@ -2440,6 +2450,10 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
>>>    	u64 first_tid = 0;
>>>    	u64 last_snap_flush = 0;
>>>    
>>> +	/* Don't do anything until create reply comes in */
>>> +	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE)
>>> +		return;
>>> +
>>>    	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
>>>    
>>>    	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
>> Is it also possible in case that just after the async unlinking request
>> is submit and a flush cap request is fired ? Then in MDS side the inode
>> could be removed from the cache and then the flush cap request comes.
>>
>>
>>
> Yes. I think that race should be fairly benign though. The MDS might
> drop the update onto the floor when it can't find the inode, but since
> the inode is already stale, I don't think we really care...

Yeah, I also didn't see this will be a problem from the kclient code for 
now.

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

>

