Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9097853FF07
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 14:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244047AbiFGMk0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 08:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243990AbiFGMkH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 08:40:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 829416431
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 05:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654605602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e2Zlz9VmrLjw+kXGkvLMQ9QxjU6eJFtutZgc3MalRVM=;
        b=Plt0Rl/B4POc+vpWo+qfQ2+Ujs4wjFyyL9xS1AQ+0cmvjq3VGOH0YA2bRBUxM9bUG32Mec
        VB65pcO7TK8ozUhP7GDzCJ9O/MNyXOfs2lTAOExSzackz35tzSeBY3hj423Q0cC2du5O99
        kW/8ZWOCrQ7iDzbgGjbl1PpxfugbId0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-iq6SAN0jOqOF2iFOf1dw6Q-1; Tue, 07 Jun 2022 08:40:01 -0400
X-MC-Unique: iq6SAN0jOqOF2iFOf1dw6Q-1
Received: by mail-pg1-f197.google.com with SMTP id h63-20020a638342000000b003fdf170580cso1653817pge.3
        for <ceph-devel@vger.kernel.org>; Tue, 07 Jun 2022 05:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=e2Zlz9VmrLjw+kXGkvLMQ9QxjU6eJFtutZgc3MalRVM=;
        b=6DNJOrBeaAE1S1VGcDwiZfS/sKb1Hw8qCNWLfOS/mdaYIVgzuagJBRYg6FA9W1Svd4
         YM//P+N04qIZAG2eJKzTxruAnzCG5ouFHcJdVT9tYqxPhJOG2ZMWY8FndQkf8LXOTvIt
         sZTtkPSlyWaLaN3jWH6UTpaR3JyaCOMw0oIRqFZvfunhkWlFEJGvNIJ9OUsK8a5fcNU4
         XSEANL1xuuaU1GgZkTeurKZUNEzGWDV+2A9PaIYyDEQ/KE9ti3COkfgbS2B29qqLdfqg
         ZTp/RR9KnP9adkLaznSBOzffdqFK6uVqD7fggLxJ4sxCDfU1slDNmHtXOtBCPt21F3gv
         i4lg==
X-Gm-Message-State: AOAM530AgFAfIdNGu77P04T0/LYMMlWv7VLxLjOD2SBKy620RxD3TezQ
        Rw21sUdLxDkVFCidec3Yq1qG31/N8G0AhxF6hPuG3MSjRYQl60eE7DRTP1iwyDoZnO4lCoHihB8
        UcPZM8Zc6OWJXO5mMmudMeOgwr0qpwbZytBVDV2LQ3xDsi6xqUejoQlPcu2uamdc0UbLIjBA=
X-Received: by 2002:a63:2360:0:b0:3fb:ee61:82cf with SMTP id u32-20020a632360000000b003fbee6182cfmr25167948pgm.574.1654605599997;
        Tue, 07 Jun 2022 05:39:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVGVt6s5klFvNGTg2QuiIq2K3WEozybpHb911ugWXy8pAvpdCVWiBlQDxOGIwDC8K92MrvYg==
X-Received: by 2002:a63:2360:0:b0:3fb:ee61:82cf with SMTP id u32-20020a632360000000b003fbee6182cfmr25167927pgm.574.1654605599653;
        Tue, 07 Jun 2022 05:39:59 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 129-20020a621787000000b005180c127200sm12661114pfx.24.2022.06.07.05.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 05:39:59 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't take inode lock in llseek
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220607112712.18023-1-jlayton@kernel.org>
 <363c9909-5f62-82ec-2008-73689435c12d@redhat.com>
 <fbba8ab7a86b18a4a2b6aadb538c0bd2c71591dd.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3ad6eb62-589b-24ed-b718-fe2a0a34bbef@redhat.com>
Date:   Tue, 7 Jun 2022 20:39:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <fbba8ab7a86b18a4a2b6aadb538c0bd2c71591dd.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
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


On 6/7/22 8:29 PM, Jeff Layton wrote:
> On Tue, 2022-06-07 at 20:23 +0800, Xiubo Li wrote:
>> On 6/7/22 7:27 PM, Jeff Layton wrote:
>>> There's no reason we need to lock the inode for write in order to handle
>>> an llseek. I suspect this should have been dropped in 2013 when we
>>> stopped doing vmtruncate in llseek.
>>>
>>> Fixes: b0d7c2231015 (ceph: introduce i_truncate_mutex)
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>    fs/ceph/file.c | 3 ---
>>>    1 file changed, 3 deletions(-)
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 0c13a3f23c99..7d2e9615614d 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -1994,8 +1994,6 @@ static loff_t ceph_llseek(struct file *file, loff_t offset, int whence)
>>>    	loff_t i_size;
>>>    	loff_t ret;
>>>    
>>> -	inode_lock(inode);
>>> -
>>>    	if (whence == SEEK_END || whence == SEEK_DATA || whence == SEEK_HOLE) {
>>>    		ret = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, false);
>>>    		if (ret < 0)
>>> @@ -2038,7 +2036,6 @@ static loff_t ceph_llseek(struct file *file, loff_t offset, int whence)
>>>    	ret = vfs_setpos(file, offset, max(i_size, fsc->max_file_size));
>>>    
>>>    out:
>>> -	inode_unlock(inode);
>>>    	return ret;
>>>    }
>>>    
>> Looks good.
>>
>> It seems the 'out' lable makes no sense anymore ?
>>
>> -- Xiubo
>>
> No, it's still used if the getattr errors out.
Yeah, I mean just return the error directly instead of doing 'goto out'.

