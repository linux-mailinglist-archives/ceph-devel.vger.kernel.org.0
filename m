Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948D9150312
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 10:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgBCJOX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 04:14:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47274 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725999AbgBCJOX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 04:14:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580721262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4jQDHJNTKsEY4ciwrx9PsgwVgEMX4L+EyY+RT37Qkw0=;
        b=gh3PXwCHj7I7raMMRj1ZXz5A54M5U9O66tX+mxGkhXcW/wfvsLgNAjUlo64j1ho/Bv0NPP
        QMEYKT+TrC5c9GJ2b8jpndQtycPKSKruI1iMCVcnENYZHUEfavI2/Gw75ZQbnYGjqeJk2E
        O9VnqTDh5B2r0Wyc94GOvhCmAqHLdm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-26JRcXbyPWa6lVUeNvWyNQ-1; Mon, 03 Feb 2020 04:14:20 -0500
X-MC-Unique: 26JRcXbyPWa6lVUeNvWyNQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5160F100550E;
        Mon,  3 Feb 2020 09:14:19 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BCD805DA82;
        Mon,  3 Feb 2020 09:14:13 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: do not direct write executes in parallel if
 O_APPEND is set
To:     Christoph Hellwig <hch@infradead.org>
Cc:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com,
        sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200131133619.14209-1-xiubli@redhat.com>
 <20200203083646.GB5005@infradead.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4956fdbe-605e-7bdb-93f5-7d28fe61568d@redhat.com>
Date:   Mon, 3 Feb 2020 17:14:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203083646.GB5005@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/3 16:36, Christoph Hellwig wrote:
> On Fri, Jan 31, 2020 at 08:36:19AM -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In O_APPEND & O_DIRECT mode, the data from different writers will
>> be possiblly overlapping each other. Just use the exclusive clock
>> instead in O_APPEND & O_DIRECT mode.
> s/clock/lock/
>
Will fix it :-)

Thanks.

BRs

