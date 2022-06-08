Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6B6543093
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 14:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbiFHMh1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 08:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239182AbiFHMh0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 08:37:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 909FE21112F
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 05:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654691840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6P5g9CxMH9agkFSN00v8QoRza+qByJ/pIWiSu9VrVw=;
        b=FwGECbB2ps3mrG65YQ4wr2IxBhY04qsz6dvRguN6l8e+1J7ygA69p4ptcsb4ozVnDx0YRW
        da6HDRzFnIXc/+V19YZileBoCozF+ewo+Qu2syXGOF4ZledD/QUb2Gbo3KntYvb2zMKqOZ
        tMAGa3InvBNIyWatm7LMXH6MiereN4o=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-gZoYs4n8NhOraT5cc8ir0A-1; Wed, 08 Jun 2022 08:37:18 -0400
X-MC-Unique: gZoYs4n8NhOraT5cc8ir0A-1
Received: by mail-pj1-f70.google.com with SMTP id il9-20020a17090b164900b001e31dd8be25so15583881pjb.3
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 05:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=r6P5g9CxMH9agkFSN00v8QoRza+qByJ/pIWiSu9VrVw=;
        b=Xp3VaLfgG/oTfm7nZ8oBmXrETTM1EcORJvV15Xasu7MmYU10NoGk4fFTf7+LMJUxTo
         o15zGzOHOCO40lNhfzvCsly72kWZNwoZxAwiJ5Oa9hsvMFtDELfLjQs59PQPwQmFQHl5
         rwZ1poIfAsbvItwB1dva+L/5c1ZOqmnaFAUOHIYrWPijdWezJRRGdag4IarY8BBG1fkX
         0UYryGp2skpe3K7V8bTqksbLoi5K4JWtRczcf13m7wDkOTFwxd8oRFlBjtpMCPC1lAwe
         gMBRVltQc8UCseGcvrxlhCfrwIat/qYJaMj4yHloFoQFGr3z+HY/tSxFwgOXKHRhZqXK
         V2Kw==
X-Gm-Message-State: AOAM533fwqJDAuDnvA6GXBqCNcOvTCSr2rhNhVBWv+cywihJxHUW0mNO
        F9Wl72cZZx3yFgY+Q41mqf1lE4vO7/aKkqI+CxWFWpHYw0ZzjXG9+1ueO6tT0vh0/XlpjR5dypL
        NwjowQ6S5AENJPGPIo2XpmVyp0eb+atMmHZJtYVQW6o+ShrlU+uOQwG5kI1kJDAzRd6ZAvuM=
X-Received: by 2002:a17:90b:4f45:b0:1e3:495a:2b51 with SMTP id pj5-20020a17090b4f4500b001e3495a2b51mr37436205pjb.3.1654691837070;
        Wed, 08 Jun 2022 05:37:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+detPOPVxzUhLZ3Er990Xlhc26u3JPIWHg406O3NPCNladz4wca/DxhxP2xFnRQUPgTxUyA==
X-Received: by 2002:a17:90b:4f45:b0:1e3:495a:2b51 with SMTP id pj5-20020a17090b4f4500b001e3495a2b51mr37436168pjb.3.1654691836540;
        Wed, 08 Jun 2022 05:37:16 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v24-20020a634658000000b003fad46ceb85sm15030753pgk.7.2022.06.08.05.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 05:37:15 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't implement writepage
To:     Jeff Layton <jlayton@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220607112703.17997-1-jlayton@kernel.org>
 <YqBDs+u6qUHOprMv@infradead.org>
 <a7c455aa0e96c1dbcbd8228ab6460d8acffe503f.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a4a63c66-e8a5-7070-f86c-be8cfc55351a@redhat.com>
Date:   Wed, 8 Jun 2022 20:37:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a7c455aa0e96c1dbcbd8228ab6460d8acffe503f.camel@kernel.org>
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


On 6/8/22 6:19 PM, Jeff Layton wrote:
> On Tue, 2022-06-07 at 23:37 -0700, Christoph Hellwig wrote:
>> Do you have an urgent need for this?  I was actually planning on sending
>> a series to drop ->writepage entirely in the next weeks, and I'd pick
>> this patch up to avoid conflicts if possible.
>>
>
> No, there's no urgent need for this. I was just following Willy's
> recommendation from LSF.
>
>> Note that you also need to implement ->migratepage to not lose any
>> functionality if dropping ->writepage, and comeing up with a good
>> solution for that is what has been delaying the series.
> Oh, I didn't realize that! I'll plan to drop this from our series for
> now. Let us know if you need us to carry any patches for this.
>
> Thanks!

Dropped it from the testing branch for now.

-- Xiubo


