Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06E622EDC4
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jul 2020 15:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgG0NoP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jul 2020 09:44:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60011 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728169AbgG0NoP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Jul 2020 09:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595857453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UsPm7jjCotFWNBzLEX4DX6y1Z/mryDFjp7QPBneG2TE=;
        b=BAuLi0hpE+LB5zd0nftEIKE1+ypqH9GyjRQCz+eYDzP56DRsCdo1UuVaAT4kq1aM0WUWLI
        8x4aSgF4pxNq9G+PQDqB2seeYL1Ct65hQQojG3jJbIOQUjzv1eWZo9i3VcWNb2033ENqMq
        LOkm2tfumwFLVzcbAv8+/8JwzGgMSz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-0Xp014_WNAOc8etWAaftkA-1; Mon, 27 Jul 2020 09:44:10 -0400
X-MC-Unique: 0Xp014_WNAOc8etWAaftkA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45794101C8A0;
        Mon, 27 Jul 2020 13:44:09 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5453A712E0;
        Mon, 27 Jul 2020 13:44:07 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix memory leak when reallocating pages array for
 writepages
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20200726122804.16008-1-jlayton@kernel.org>
 <3c8fb2aa-834b-a202-24b4-7eb29cd9b7c3@redhat.com>
 <ff6497016429a0ba962d97d6997427a5020ac6d4.camel@kernel.org>
 <f1265009-9d5c-4685-8ecf-8e06e7500baa@redhat.com>
 <b9c88da029462acd45dea1035e5be3c4f40463d0.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <96aa56d1-ce71-27b4-67c1-32da656fd329@redhat.com>
Date:   Mon, 27 Jul 2020 21:44:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b9c88da029462acd45dea1035e5be3c4f40463d0.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/27 21:35, Jeff Layton wrote:
> On Mon, 2020-07-27 at 21:27 +0800, Xiubo Li wrote:
>> On 2020/7/27 21:18, Jeff Layton wrote:
>>> On Mon, 2020-07-27 at 20:16 +0800, Xiubo Li wrote:
>>>> On 2020/7/26 20:28, Jeff Layton wrote:
>>>>> Once we've replaced it, we don't want to keep the old one around
>>>>> anymore.
>>>>>
>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>> ---
>>>>>     fs/ceph/addr.c | 1 +
>>>>>     1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>>>> index 01ad09733ac7..01e167efa104 100644
>>>>> --- a/fs/ceph/addr.c
>>>>> +++ b/fs/ceph/addr.c
>>>>> @@ -1212,6 +1212,7 @@ static int ceph_writepages_start(struct address_space *mapping,
>>>>>     			       locked_pages * sizeof(*pages));
>>>>>     			memset(data_pages + i, 0,
>>>>>     			       locked_pages * sizeof(*pages));
>>>> BTW， do we still need to memset() the data_pages ?
>>>>
>>> Self-NAK on this patch...
>>>
>>> Zheng pointed out that this array is actually freed by the request
>>> handler after the submission. This loop is creating a new pages array
>>> for a second request.
>> Do you mean ceph_osd_data_release() ?
>>
>> The request is only freeing the pages in that arrary, not the arrary
>> itself, did I miss something ?
>>
>>
> No, I meant in writepages_finish(). It has this:
>
>          if (osd_data->pages_from_pool)
>                  mempool_free(osd_data->pages,
>                               ceph_sb_to_client(inode->i_sb)->wb_pagevec_pool);
>          else
>                  kfree(osd_data->pages);
>
> The pages themselves are freed in the loop above that point however.

Okay, that's right.

Thanks.


>>> As far as whether we need to memset the end of the original array...I
>>> don't think we do. It looks like the pointers at the end of the array
>>> are ignored once you go past the length of the request. That said, it's
>>> fairly cheap to do so, and I'm not inclined to change it, just in case
>>> there is code that does look at those pointers.
>>>
>>>>> +			kfree(data_pages);
>>>>>     		} else {
>>>>>     			BUG_ON(num_ops != req->r_num_ops);
>>>>>     			index = pages[i - 1]->index + 1;


