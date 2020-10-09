Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D60F288A8A
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Oct 2020 16:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388597AbgJIOSJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Oct 2020 10:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729280AbgJIOSI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Oct 2020 10:18:08 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5A5C0613D7
        for <ceph-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:18:07 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id a9so8006584qto.11
        for <ceph-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CcKsaaPzQT2ESj6YOvwBkh06P5IZh1MGDwlgLgs4VHo=;
        b=NlLNJz0gReMZ2olYoTwOI71Q3J7hZ4eCjDSLwfxrDsINskB/uRN0RJ63/6e4mp7rWK
         8HBBtYSi0tq6rQFBsNjlT8Imwpm8kDcN4jK2nSy7e062CLRT5RQCSFjHf1lN8ImYUGqc
         /vhv7tZjTIgwahWg6NDlOfjzYJ70RBtTYFaUtayjCmBbBlk6KxW8RzL4UWdAG77v2I9N
         A7UYx+wU+9EnXtsWlWiz3jQTPpdXvIdYWAVVCCCHPiVwb88OgPGRxAtC9APpf83BXrog
         jD06zR6/j/9ASrwFeC4hcqIdoEkQl6E5WRGzyO2rSgnCpr/6ATUZ0Ujgycjt3F5z1/Cd
         Sd+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CcKsaaPzQT2ESj6YOvwBkh06P5IZh1MGDwlgLgs4VHo=;
        b=qJi2G0QVHvKNsvNye5tYASVgkE4glSuHevDr40z9ESfCePEKAPom9g1L14da6ZHIJ7
         1j1jWD0k9hM1+JdkmC6MlfWOBpFKSlUDSXrF7q83bWk+18FTG4N83f/8Bq0h9FREiOL4
         DehqMBFIZHiNTrliLlDEquTY7RD+vatH3nufONLL9BPb0MuGZKqEoiGHYpngIqOeu9F4
         9JDBZ8ZcLPHmY7DBYPksYrBwT8NfKJTPQ9olCnTWHTJzKKMY/FLXMRbWpCRsU5yfkte6
         UqcBWAmQ7w0qmd51zZS3fvYvH7taVSltFw51tXxRVEMZbemdhTLcob7E/ilxjRa8h6+F
         r+sQ==
X-Gm-Message-State: AOAM530Q1ci8+I/KncaG8nEhOkQZ4wDR3+lZMRAppd0Ak8Ajc93ezNwi
        5qSBUQgtD9M8OuxhGsokHCLA1LvcpEmJYA==
X-Google-Smtp-Source: ABdhPJxkUTamFkDclFTulS7UVScV42JPT3TSQbrdjQZFe2ID/ahDqSFwMiv5AdzptTI3yxVlMZazyg==
X-Received: by 2002:ac8:5d04:: with SMTP id f4mr13754639qtx.290.1602253085840;
        Fri, 09 Oct 2020 07:18:05 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11e8::107d? ([2620:10d:c091:480::1:f1f8])
        by smtp.gmail.com with ESMTPSA id f3sm6216160qtp.57.2020.10.09.07.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 07:18:03 -0700 (PDT)
Subject: Re: [PATCH 5/7] btrfs: Promote to unsigned long long before shifting
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk,
        jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.com,
        stable@vger.kernel.org
References: <20201004180428.14494-1-willy@infradead.org>
 <20201004180428.14494-6-willy@infradead.org>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <b36885cc-0c4b-ee03-bcd3-56f94800d84e@toxicpanda.com>
Date:   Fri, 9 Oct 2020 10:18:01 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201004180428.14494-6-willy@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 10/4/20 2:04 PM, Matthew Wilcox (Oracle) wrote:
> On 32-bit systems, this shift will overflow for files larger than 4GB.
> 
> Cc: stable@vger.kernel.org
> Fixes: df480633b891 ("btrfs: extent-tree: Switch to new delalloc space reserve and release")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
