Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C45554AD4A
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jun 2022 11:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356114AbiFNJYj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jun 2022 05:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356119AbiFNJYX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 14 Jun 2022 05:24:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 347FA48317
        for <ceph-devel@vger.kernel.org>; Tue, 14 Jun 2022 02:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655198584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wL500kuZofPLhlgg9MWpmsN25gKPcsSWCkD4qrvFYPQ=;
        b=PtsGmZkAgW438UTZRKCzZYKxCY8hNHtNhwV9eiZHaxQPtLS0/CNHGfKYBUilhKEz0h8cvN
        vu2/MDbQlkzbplVcDczG1smvHSYFyMbgQIuQXnk2cvAv1QPJKyNSDOub0t3JW48jh2SosM
        gKygsqx0mQnHlCY4LFNBJszXdKtPFdA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-9JwemaHFNziIgm37k5kTMg-1; Tue, 14 Jun 2022 05:23:03 -0400
X-MC-Unique: 9JwemaHFNziIgm37k5kTMg-1
Received: by mail-pj1-f70.google.com with SMTP id lw3-20020a17090b180300b001e31fad7d5aso7878370pjb.6
        for <ceph-devel@vger.kernel.org>; Tue, 14 Jun 2022 02:23:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wL500kuZofPLhlgg9MWpmsN25gKPcsSWCkD4qrvFYPQ=;
        b=uF1II1dYNLWmi8NuMCoorrOjXVD2xMrxVdKpxGzTizkHyaleUzrH9pv4r886gIWbXm
         i7lXiiMSo9446yPomaDbcxvdopZB/f9khxq/R7zilMIXDsBSbaRGqs8w72Am+LgLY1EV
         pRnS4IRcgBwxALPjanX2O5zzBMYtznnpvF4+fSP45gs3TCriS0GPTOjVqvvRb+6pyMrm
         yiNAYq8O8V1GilMniQqSPAx1Vl6XVB5KVr0sr5Tel+PXXD0UnDj+IEtivgDQW850EoUs
         B1bVj8ODQlHZIFR2bhoAcCwFyvau2O4YJcxv9YurPmenxigtlgcR2i1wmIf+qfk0LcGI
         2lcw==
X-Gm-Message-State: AOAM531ZTH8vqQhSLZBkOaKooHttgH9UEFA/AfNIFTc7/XfNHdNGg6K4
        3VkNlZ5DLHxjZlUTvusr56SPkZrWYjbG4BeE9uqv19jE6msSY2Ci3h2ud3I82Tvju4fxArEy86J
        W+puye5qjy1pOeSJmLd2y1YNn84+D6jKgM9mREB0O+CMFGIXZQjEkmL003dcoCPIJtKKWdcs=
X-Received: by 2002:a63:1d46:0:b0:3fd:df71:dac0 with SMTP id d6-20020a631d46000000b003fddf71dac0mr3735065pgm.258.1655198581947;
        Tue, 14 Jun 2022 02:23:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcGgH+akAFo0vy21bwAxO7etCG+oDCVa+C3+GEbh6r+OW4jesY61jKu90/RhECEgkZdqTjPQ==
X-Received: by 2002:a63:1d46:0:b0:3fd:df71:dac0 with SMTP id d6-20020a631d46000000b003fddf71dac0mr3735043pgm.258.1655198581584;
        Tue, 14 Jun 2022 02:23:01 -0700 (PDT)
Received: from [10.72.12.99] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r7-20020aa79627000000b0051bce5dc754sm6990536pfg.194.2022.06.14.02.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 02:23:00 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] Two xattrs-related fixes for ceph
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>, Zorro Lang <zlang@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220613113142.4338-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e41f28f7-fbd0-e861-603f-0813b91fe3ed@redhat.com>
Date:   Tue, 14 Jun 2022 17:22:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220613113142.4338-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/13/22 7:31 PM, Luís Henriques wrote:
> Hi!
>
> A bug fix in ceph has made some changes in the way xattr limits are
> enforced on the client side.  This requires some fixes on tests
> generic/020 and generic/486.
>
> * Changes since v2:
>
>    - patch 0001:
>      Add logic to compute the *real* maximum.  Kudos to David Disseldorp
>      for providing the right incantation to do the maths.  Also split
>      _attr_get_max() in two, so that they can be invoked from different
>      places in the test script.
>
>    - patch 002:
>      attr_replace_test now has an extra param as suggested by Dave Chinner,
>      and added fs-specific logic to the script.  No need to have an exact
>      maximum in this test, a big-enough value suffices.
>
> * Changes since v1:
>
>    - patch 0001:
>      Set the max size for xattrs values to a 65000, so that it is close to
>      the maximum, but still able to accommodate any pre-existing xattr
>
>    - patch 0002:
>      Same thing as patch 0001, but in a more precise way: actually take
>      into account the exact sizes for name+value of a pre-existing xattr.
>
> Luís Henriques (2):
>    generic/020: adjust max_attrval_size for ceph
>    generic/486: adjust the max xattr size
>
>   src/attr_replace_test.c | 30 ++++++++++++++++++++++++++----
>   tests/generic/020       | 33 +++++++++++++++++++++++++--------
>   tests/generic/486       | 11 ++++++++++-
>   3 files changed, 61 insertions(+), 13 deletions(-)
>
This series looks good to me.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


