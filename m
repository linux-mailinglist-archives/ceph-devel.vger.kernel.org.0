Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7517D36D042
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Apr 2021 03:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbhD1BZ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Apr 2021 21:25:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhD1BZ7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 21:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619573114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZyeUy72Xz7hz/2Xt7e+ap5zFqfGZdTG7DZGjdNwXOP8=;
        b=JD3QZDUAq+ocRWXZt1Ic3x7rq83frISDwKon08fTqTlsHAjuwIhtxcQyF6HzBtfCbIxnXc
        dPyyZuUHtBAEpUV0Tdzn+koieVZpWKOy+gq0Uhxfuomq2I25U11KEkuekMz8gQsVX7cPSG
        s6nXiGudZKKjYnfsvnNUSvFmZBl1Zp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-pwjByYz7MWKF2YciR3bgQA-1; Tue, 27 Apr 2021 21:25:11 -0400
X-MC-Unique: pwjByYz7MWKF2YciR3bgQA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B426A1020C21;
        Wed, 28 Apr 2021 01:25:09 +0000 (UTC)
Received: from [10.72.13.181] (ovpn-13-181.pek2.redhat.com [10.72.13.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C59F5D9F0;
        Wed, 28 Apr 2021 01:25:07 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] ceph: add IO size metrics support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210325032826.1725667-1-xiubli@redhat.com>
 <20210325032826.1725667-3-xiubli@redhat.com>
 <398f8ebf7ca9f29694ec5be3ddc3f04a7c1ee660.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7a23da97-6e2c-3e8b-b5a7-436c913c0f30@redhat.com>
Date:   Wed, 28 Apr 2021 09:24:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <398f8ebf7ca9f29694ec5be3ddc3f04a7c1ee660.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/4/28 2:41, Jeff Layton wrote:
> On Thu, 2021-03-25 at 11:28 +0800, xiubli@redhat.com wrote:
...
>> +static inline void __update_size(struct ceph_client_metric *m,
>> +				 metric_type type, unsigned int size)
>> +{
>> +	switch (type) {
>> +	case CEPH_METRIC_READ:
>> +		++m->total_reads;
>> +		m->read_size_sum += size;
>> +		METRIC_UPDATE_MIN_MAX(m->read_size_min,
>> +				      m->read_size_max,
>> +				      size);
>> +		return;
>> +	case CEPH_METRIC_WRITE:
>> +		++m->total_writes;
>> +		m->write_size_sum += size;
>> +		METRIC_UPDATE_MIN_MAX(m->write_size_min,
>> +				      m->write_size_max,
>> +				      size);
>> +		return;
>> +	case CEPH_METRIC_METADATA:
>> +	default:
>> +		return;
>> +	}
>> +}
>> +
> Ditto here re: patch 1. This switch adds nothing and just adds in some
> extra branching. I'd just open code these into their (only) callers.

Sure.



