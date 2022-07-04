Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE355564B65
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Jul 2022 03:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiGDBzq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 3 Jul 2022 21:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiGDBzp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 3 Jul 2022 21:55:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D952E1F9
        for <ceph-devel@vger.kernel.org>; Sun,  3 Jul 2022 18:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656899744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PSwib5RvbjLiixaPstM+uVWXsecwFa/9MMM1V5OyNh8=;
        b=RIkvIKTFmK9zBl63z2Cccvw3mck0k1xpMaeg2em+7NrPT0/7PlL3N9F+uo4d8qa7DlS9Xa
        PeeMJtYVH7vaecYo4EMbGcGxlhbCr3ossRa/kes+GJzhfwUuShq+sRC62X/GQ2xDDzbfZF
        54BzyI1Qh1FVTfKo75zt4keiHhUOGpg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-NusP7JmMPASnLpFhGk74UQ-1; Sun, 03 Jul 2022 21:55:42 -0400
X-MC-Unique: NusP7JmMPASnLpFhGk74UQ-1
Received: by mail-pl1-f200.google.com with SMTP id k11-20020a170902c40b00b0016bac120046so4312946plk.0
        for <ceph-devel@vger.kernel.org>; Sun, 03 Jul 2022 18:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PSwib5RvbjLiixaPstM+uVWXsecwFa/9MMM1V5OyNh8=;
        b=Cla/anrNX+wRFGx1H23/YzPHv3Bzem8TDydRuVxqEUsKmTz47YLa1sRgKAK2SRD+e7
         GJ7miWBCyqIZkzBmqzyaXuG5YPQ7mzHWqgfDVK1kly59OvmwDwd4UqrtULqM925RvqIV
         m6dadwe7W7+zXMc8m+b4kgaDjSjEMIJ8ralg3iHYTfyCB1JPYlwoXcHpPUTEnoVaa5YI
         n/DUTYdEQH1zJbLeCOusqj83AazM6MoAHWXQxWKw5i18Ypq3LvS1X0RXxaBnhmKqjI8u
         CccrNXhPyY4yfesUFM68kSpIUynFxnvqjezA2RLjAE2S3KcDrrJcjoli0B65t4frHrmy
         k+Fg==
X-Gm-Message-State: AJIora8DpNmXD46D5yHJEbfuaQKvrDBZXsApjdQUv3acnYzRKQ6h/cUg
        PvQk8VRmGJ5Uf1nBLKpB73uV7rHVg4+5agJdEt0PHHUSm3bBJUzPAKHqaAqj37nGbGyklr4FpBO
        CuJdS9UcfehU2UWHFzT05nY+l8JNJq1VqETcW4ROZoqhe13JojextYIKvN+Fz/fzCV+R2I2Q=
X-Received: by 2002:a63:714f:0:b0:40c:b278:ebab with SMTP id b15-20020a63714f000000b0040cb278ebabmr23609628pgn.598.1656899741070;
        Sun, 03 Jul 2022 18:55:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sR4mS7jue37CP4g2N6KP92lywlY3oKLwNQh4EMTpFwfZK46pPIk6Tpp4i5ycHp8tq2OF5XMQ==
X-Received: by 2002:a63:714f:0:b0:40c:b278:ebab with SMTP id b15-20020a63714f000000b0040cb278ebabmr23609603pgn.598.1656899740679;
        Sun, 03 Jul 2022 18:55:40 -0700 (PDT)
Received: from [10.72.12.186] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902dacb00b001635b86a790sm20083065plx.44.2022.07.03.18.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 18:55:39 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] libceph: add new iov_iter msg_data type and use it
 for reads
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
References: <20220701103013.12902-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7d28821c-d911-8bc8-15f1-4faa70795e0e@redhat.com>
Date:   Mon, 4 Jul 2022 09:55:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220701103013.12902-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/1/22 6:30 PM, Jeff Layton wrote:
> v3:
> - flesh out kerneldoc header over osd_req_op_extent_osd_data_pages
> - remove export of ceph_msg_data_add_iter
>
> v2:
> - make _next handler advance the iterator in preparation for coming
>    changes to iov_iter_get_pages
>
> Just a respin to address some minor nits pointed out by Xiubo.
>
> ------------------------8<-------------------------
>
> This patchset was inspired by some earlier work that David Howells did
> to add a similar type.
>
> Currently, we take an iov_iter from the netfs layer, turn that into an
> array of pages, and then pass that to the messenger which eventually
> turns that back into an iov_iter before handing it back to the socket.
>
> This patchset adds a new ceph_msg_data_type that uses an iov_iter
> directly instead of requiring an array of pages or bvecs. This allows
> us to avoid an extra allocation in the buffered read path, and should
> make it easier to plumb in write helpers later.
>
> For now, this is still just a slow, stupid implementation that hands
> the socket layer a page at a time like the existing messenger does. It
> doesn't yet attempt to pass through the iov_iter directly.
>
> I have some patches that pass the cursor's iov_iter directly to the
> socket in the receive path, but it requires some infrastructure that's
> not in mainline yet (iov_iter_scan(), for instance). It should be
> possible to something similar in the send path as well.
>
> Jeff Layton (2):
>    libceph: add new iov_iter-based ceph_msg_data_type and
>      ceph_osd_data_type
>    ceph: use osd_req_op_extent_osd_iter for netfs reads
>
>   fs/ceph/addr.c                  | 18 +------
>   include/linux/ceph/messenger.h  |  8 ++++
>   include/linux/ceph/osd_client.h |  4 ++
>   net/ceph/messenger.c            | 84 +++++++++++++++++++++++++++++++++
>   net/ceph/osd_client.c           | 27 +++++++++++
>   5 files changed, 124 insertions(+), 17 deletions(-)
>
Merged into the testing branch and will run the tests.

Thanks Jeff!

-- Xiubo


