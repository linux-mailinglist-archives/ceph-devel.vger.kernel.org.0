Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58BB59534F
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Aug 2022 09:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiHPHFP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Aug 2022 03:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiHPHEv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Aug 2022 03:04:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B44C5118936
        for <ceph-devel@vger.kernel.org>; Mon, 15 Aug 2022 19:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660617162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V2TnLkeyTV2uf8G2l7EU3nCpz0fVF4Uigf2px7a9u4s=;
        b=LNYIgJQHJcSanNd7o6oLtRwUN+7R0QvnBMZF1HA7RJrXvgL23k/79JkjtyMwmqeKF0+Ja+
        ZQ7i0eRoNBIThCwXipYBNIclcH9dZViVRa38b/4FkCJxpdkzQYpbP3h302Qn93FoBw97P8
        yTUhsE8VugpPWNTIrbvlXI1wLBby1Mo=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-551-s2VKY129P4aYbDU-95FBMQ-1; Mon, 15 Aug 2022 22:32:41 -0400
X-MC-Unique: s2VKY129P4aYbDU-95FBMQ-1
Received: by mail-pl1-f197.google.com with SMTP id s18-20020a170902ea1200b0016f11bfefe4so5843409plg.14
        for <ceph-devel@vger.kernel.org>; Mon, 15 Aug 2022 19:32:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=V2TnLkeyTV2uf8G2l7EU3nCpz0fVF4Uigf2px7a9u4s=;
        b=LSFrbTGNI7ZlTz+jfl10/ICcQ0cnYCwyTlqeB/a2IZeTdioNFdNpjB64QIXMb+GUes
         gvrBKPIsEJ5RaXLs8RRcIfRs7vfwL1kE+845JJde2cowmTUc+sl2KorNtxSdAcPCZh0f
         MTOc+fETqPyD1TVgDvHSGVtdxnHEsXPzA2ECwTJMF/6uvgrPHhUGz198VC1vEk43rUc5
         5mmHWxTOAp4XSmVUeLoRzQtSXkpLTu029w/jKY+wclsp+R/ggeotuHQ0nGywxv1jMv2I
         qOZwoHNB7x/eVwqOgJcmpE/xhXbnNiHdBHx5MXaMHTDwgMr6rwHTna3Jn75jXkm+8EI1
         MHeQ==
X-Gm-Message-State: ACgBeo0tfwsLm4b2mfYEZi0UZYheM3km0lOuJcPSvzoGEOdm2BzYwsdA
        BYVKrZePJp2LkMAjupuEGYdKv6KKRQh28lBRydbnpUihww87wnY5XHWGPf6+/nCx+gVJCrJE6Sk
        C8JwLqrAZU3Skt58PUAGF5Q==
X-Received: by 2002:a17:902:e881:b0:172:62c8:b44f with SMTP id w1-20020a170902e88100b0017262c8b44fmr11740449plg.8.1660617160430;
        Mon, 15 Aug 2022 19:32:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6qF9/w0jOYSysfOOZ01I3rf1+Pquv7170Uk10LS1DC9/dEofCH8syLLLl8DmlMV+rSOQ79UA==
X-Received: by 2002:a17:902:e881:b0:172:62c8:b44f with SMTP id w1-20020a170902e88100b0017262c8b44fmr11740431plg.8.1660617160124;
        Mon, 15 Aug 2022 19:32:40 -0700 (PDT)
Received: from [10.72.12.61] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 1-20020a170902c20100b0016b81679c1fsm7677028pll.216.2022.08.15.19.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 19:32:39 -0700 (PDT)
Subject: Re: [ceph-client:testing 14/39] net/ceph/messenger.c:988:15: error:
 implicit declaration of function 'iov_iter_get_pages'; did you mean
 'iov_iter_get_pages2'?
To:     kernel test robot <lkp@intel.com>, Jeff Layton <jlayton@kernel.org>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
References: <202208160842.GUNdBYbK-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4e8bfcdd-d502-464d-e261-e7844c04e941@redhat.com>
Date:   Tue, 16 Aug 2022 10:32:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202208160842.GUNdBYbK-lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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


On 8/16/22 8:35 AM, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   bc940dc5cc27be90472e00ddf510b28b29ffd6ce
> commit: a5cb140194256429d5ce74439e8165390d9380a6 [14/39] libceph: add new iov_iter-based ceph_msg_data_type and ceph_osd_data_type
> config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220816/202208160842.GUNdBYbK-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
> reproduce (this is a W=1 build):
>          # https://github.com/ceph/ceph-client/commit/a5cb140194256429d5ce74439e8165390d9380a6
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client testing
>          git checkout a5cb140194256429d5ce74439e8165390d9380a6
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/ceph/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     net/ceph/messenger.c: In function 'ceph_msg_data_iter_next':
>>> net/ceph/messenger.c:988:15: error: implicit declaration of function 'iov_iter_get_pages'; did you mean 'iov_iter_get_pages2'? [-Werror=implicit-function-declaration]
>       988 |         len = iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
>           |               ^~~~~~~~~~~~~~~~~~
>           |               iov_iter_get_pages2
>     cc1: some warnings being treated as errors
>
Thanks for reporting this.

Al has changed it to auto-advance  iterator, the following patch should 
fix it:


diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 945f6d1a9efa..020474cf137c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -985,25 +985,12 @@ static struct page *ceph_msg_data_iter_next(struct 
ceph_msg_data_cursor *cursor,
         if (cursor->lastlen)
                 iov_iter_revert(&cursor->iov_iter, cursor->lastlen);

-       len = iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
-                                1, page_offset);
+       len = iov_iter_get_pages2(&cursor->iov_iter, &page, PAGE_SIZE,
+                                 1, page_offset);
         BUG_ON(len < 0);

         cursor->lastlen = len;

-       /*
-        * FIXME: Al Viro says that he will soon change iov_iter_get_pages
-        * to auto-advance the iterator. Emulate that here for now.
-        */
-       iov_iter_advance(&cursor->iov_iter, len);
-
-       /*
-        * FIXME: The assumption is that the pages represented by the 
iov_iter
-        *        are pinned, with the references held by the upper-level
-        *        callers, or by virtue of being under writeback. 
Eventually,
-        *        we'll get an iov_iter_get_pages variant that doesn't 
take page
-        *        refs. Until then, just put the page ref.
-        */
         VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
         put_page(page);

-- Xiubo



> vim +988 net/ceph/messenger.c
>
>     977	
>     978	static struct page *ceph_msg_data_iter_next(struct ceph_msg_data_cursor *cursor,
>     979							size_t *page_offset,
>     980							size_t *length)
>     981	{
>     982		struct page *page;
>     983		ssize_t len;
>     984	
>     985		if (cursor->lastlen)
>     986			iov_iter_revert(&cursor->iov_iter, cursor->lastlen);
>     987	
>   > 988		len = iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
>     989					 1, page_offset);
>     990		BUG_ON(len < 0);
>     991	
>     992		cursor->lastlen = len;
>     993	
>     994		/*
>     995		 * FIXME: Al Viro says that he will soon change iov_iter_get_pages
>     996		 * to auto-advance the iterator. Emulate that here for now.
>     997		 */
>     998		iov_iter_advance(&cursor->iov_iter, len);
>     999	
>    1000		/*
>    1001		 * FIXME: The assumption is that the pages represented by the iov_iter
>    1002		 * 	  are pinned, with the references held by the upper-level
>    1003		 * 	  callers, or by virtue of being under writeback. Eventually,
>    1004		 * 	  we'll get an iov_iter_get_pages variant that doesn't take page
>    1005		 * 	  refs. Until then, just put the page ref.
>    1006		 */
>    1007		VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
>    1008		put_page(page);
>    1009	
>    1010		*length = min_t(size_t, len, cursor->resid);
>    1011		return page;
>    1012	}
>    1013	
>

