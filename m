Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488F52492A7
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 04:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHSCB1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Aug 2020 22:01:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38225 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727955AbgHSCBV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Aug 2020 22:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597802480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e7yUsvd0/CDCJmA6+2TfThyX2t6/kq8wfcwNJtFMxBw=;
        b=dReZRj3v65AcSAed08irh0nie1Cpb4EO0QV4EJR9h09b6rlgPOZAxysufk76O/M4HSbTw/
        StA01rlRoj6vIvZqEfMhU95EHTWRk32JmB115zhKRnOFm/Tu9DR0/RW6khIWyDVLpq/Mbx
        HSC2gTETCwV1vbMDs4rfRO0MoKNYatw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-Cn8kuZ5mMHyvslLP56IgOg-1; Tue, 18 Aug 2020 22:01:16 -0400
X-MC-Unique: Cn8kuZ5mMHyvslLP56IgOg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E0F81019628;
        Wed, 19 Aug 2020 02:01:15 +0000 (UTC)
Received: from [10.72.12.38] (ovpn-12-38.pek2.redhat.com [10.72.12.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E027E6CE4E;
        Wed, 19 Aug 2020 02:01:07 +0000 (UTC)
Subject: Re: [PATCH] ceph: add dirs/files' opened/opening metric support
To:     Patrick Donnelly <pdonnell@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200818115317.104579-1-xiubli@redhat.com>
 <7b1e716346aee082cd1ff426faf6b9bff0276ae0.camel@kernel.org>
 <CA+2bHPZoHhaEBKBKGiR6=Ui7NYnLyT-fMUYHvCcXtT2-oWXRdg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d2bb621f-5bfa-c936-b589-e13ae13cc6d9@redhat.com>
Date:   Wed, 19 Aug 2020 10:01:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+2bHPZoHhaEBKBKGiR6=Ui7NYnLyT-fMUYHvCcXtT2-oWXRdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/8/19 4:10, Patrick Donnelly wrote:
> On Tue, Aug 18, 2020 at 1:05 PM Jeff Layton <jlayton@kernel.org> wrote:
>> Bear in mind that if the same file has been opened several times, then
>> you'll get an increment for each.
> Having an open file count (even for the same inode) and a count of
> inodes opened sounds useful to me. The latter would require some kind
> of refcounting for each inode? Maybe that's too expensive though.

For the second, yes, we need one percpu refcount, which can be add in 
ceph_get_fmode() when increasing any entry of the 
ci->i_nr_by_mode[fmode] for the first time, to decrease it in 
ceph_put_fmode() when the ci->i_nr_by_mode[fmode] is empty. IMO, it 
should be okay and won't cost too much.

Thanks

BRs

>
>> Would it potentially be more useful to report the number of inodes that
>> have open file descriptions associated with them? It's hard for me to
>> know as I'm not clear on the intended use-case for this.
> Use-case is more information available via `fs top`.
>

