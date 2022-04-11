Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A713E4FB7EE
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Apr 2022 11:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344661AbiDKJp1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Apr 2022 05:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiDKJp0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Apr 2022 05:45:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E11E37BC7
        for <ceph-devel@vger.kernel.org>; Mon, 11 Apr 2022 02:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649670192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/BCrngVH+Pg62263zBa7fh4IGLRK0WweItI+0L7hTyk=;
        b=BFYKQ09bergC/xe049r7CcRNrFaaRmO74kmXKYfwsDTpUcPbY6u3G/87dmpSJmsX8g7cG+
        2aqvGnj55BGQ2hYX32zWuTM6krmdZTPmb8dJ7SniYojDfonKQoyeavlQhBTNq9P4A3UNJr
        XMHh0cmYm8DQjRAUjRNu231WJtPH7dc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-qCtL8VoVMficqXmpszdhzw-1; Mon, 11 Apr 2022 05:43:10 -0400
X-MC-Unique: qCtL8VoVMficqXmpszdhzw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 876C41C05B02;
        Mon, 11 Apr 2022 09:43:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F27B1415125;
        Mon, 11 Apr 2022 09:43:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220411021207.268351-1-xiubli@redhat.com>
References: <20220411021207.268351-1-xiubli@redhat.com>
To:     xiubli@redhat.com
Cc:     dhowells@redhat.com, jlayton@kernel.org, idryomov@gmail.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: fix statx AT_STATX_DONT_SYNC vs AT_STATX_FORCE_SYNC check
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1082020.1649670188.1@warthog.procyon.org.uk>
Date:   Mon, 11 Apr 2022 10:43:08 +0100
Message-ID: <1082021.1649670188@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

xiubli@redhat.com wrote:

> From the posix and the initial statx supporting commit comments,
> the AT_STATX_DONT_SYNC is a lightweight stat flag and the
> AT_STATX_FORCE_SYNC is a heaverweight one.

They're not flags.  It's an enumeration overlain on the at_flags parameter
because syscalls have a limited number of parameters.

> And also checked all
> the other current usage about these two flags they are all doing
> the same, that is only when the AT_STATX_FORCE_SYNC is not set
> and the AT_STATX_DONT_SYNC is set will they skip sync retriving
> the attributes from storage.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>

Reviewed-by: David Howells <dhowells@redhat.com>

