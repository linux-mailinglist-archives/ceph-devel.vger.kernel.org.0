Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750AE547085
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Jun 2022 02:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242913AbiFKAaO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 20:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiFKAaN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 20:30:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CC22A455
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jun 2022 17:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654907411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5OL6vaR29CSd0C0Wg6l0H8lMEbOsp7IS06owvkzJSJc=;
        b=N4y+pnLy+0fM0C5cfd38vpFMPzvzJlWaY/ey/3c0cWKy2TCzvZW5Ue/h1MOQtQiYSdgKXn
        lb4SW715t+atCH/6i9O8rE+oa6AbKoTp0DkHebT7fxv+j+Z4M8lJKs9al39n0+/ArJ8Snn
        Gviy7Si7JIY3qVGTpVP0HZjXEXMunwU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-DjFV7Wi5P6i9uABw07_zDw-1; Fri, 10 Jun 2022 20:30:09 -0400
X-MC-Unique: DjFV7Wi5P6i9uABw07_zDw-1
Received: by mail-pf1-f200.google.com with SMTP id 144-20020a621496000000b0051ba2e95df2so333766pfu.11
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jun 2022 17:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5OL6vaR29CSd0C0Wg6l0H8lMEbOsp7IS06owvkzJSJc=;
        b=j0/ixaKFbhHqNjYzWTNFQ80JsVK1qkEKf5UZT+AiRZS3i99TaXSqkOZxK68BQq3AxP
         lsacmO8WjKJxqqP8friGe333gJA3ZyTGFYVCmsEXlsmUZ1YDFkK20Tv0yDexlWmdkdaN
         lgHYmp8MxzEuLspaQ7JKU8P5S0YKYIr6IXA/5CFsEsnTY+cKtRKvZXpb/tMge1pyAvYP
         UAIlsK0Sg+GXPwgzqVZzFsY+zwLfFdlHoZ0EJAF+SPGTWVXLkUvSNvDnPgY0lyTsG7ab
         Rvrmt3SY3hRDbvQFxgaSFUGIEQMRXQwAYVp54XeF/Y7fSzks2ZNnunEKlM0kieY3oDY3
         M/tw==
X-Gm-Message-State: AOAM531vhqZcr/NgN0TwJXzQjvGp4JdyV6NmXbjd9dJvNnbLFIaLApYN
        CDH69FUSohsC3jTKGBD3GCCGEslJ0udhxp84fVusoAkREwGGrQ+4ppug3poWBkIGgX7RpIkUvnL
        qk29AHzXBbTwPATLNsNgVRw==
X-Received: by 2002:a17:902:d652:b0:168:bffe:e5fe with SMTP id y18-20020a170902d65200b00168bffee5femr4491562plh.81.1654907408737;
        Fri, 10 Jun 2022 17:30:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxP0cVNtxNZgxGQUvFDzyRGFnacdSCJcsyUB1BEZWXu/kYMhTyBgSPE7t00vH1Xo8n3R65h8w==
X-Received: by 2002:a17:902:d652:b0:168:bffe:e5fe with SMTP id y18-20020a170902d65200b00168bffee5femr4491547plh.81.1654907408482;
        Fri, 10 Jun 2022 17:30:08 -0700 (PDT)
Received: from [10.72.12.41] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g2-20020aa78182000000b0051bf246ca2bsm157688pfi.100.2022.06.10.17.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 17:30:07 -0700 (PDT)
Subject: Re: [PATCH] ceph: call netfs_subreq_terminated with was_async ==
 false
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
References: <20220607182218.234138-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7d3bb725-8f37-3088-52c4-ba22bc93445c@redhat.com>
Date:   Sat, 11 Jun 2022 08:30:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220607182218.234138-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
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


On 6/8/22 2:22 AM, Jeff Layton wrote:
> "was_async" is a bit misleadingly named. It's supposed to indicate
> whether it's safe to call blocking operations from the context you're
> calling it from, but it sounds like it's asking whether this was done
> via async operation. For ceph, this it's always called from kernel
> thread context so it should be safe to set this to false.
>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/addr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 3489444c55b9..39e2c64d008f 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -241,7 +241,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
>   	if (err >= 0 && err < subreq->len)
>   		__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
>   
> -	netfs_subreq_terminated(subreq, err, true);
> +	netfs_subreq_terminated(subreq, err, false);
>   
>   	num_pages = calc_pages_for(osd_data->alignment, osd_data->length);
>   	ceph_put_page_vector(osd_data->pages, num_pages, false);

Sorry, I think I missed this one.

LGTM. Thanks Jeff !

-- Xiubo

