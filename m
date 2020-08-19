Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9BE24A04B
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 15:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgHSNou (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 09:44:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57682 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726961AbgHSNoe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 09:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597844673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rhcu+4K0m5aofycLQzSfqoyYXL5iS9LgFlcYKjSifEY=;
        b=FYYDV3L6xs3IwbO9uSSYZMOISY5J+Tpp1BlxwWpzeAvoBq3jgpYXnTKD8OKplTvOHZb0ss
        Hbdbjj/SyJjNW2n/Y9VOMiRNNXa8lp2iJgpyMlXVBgjs5VOX4JAvJXrQKkHl+TbBSUtzPV
        gWgwZ9fgN3EosYD9uWuNtApCwHUVuoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-HHGvWZCjNWW6SPzbA91U1w-1; Wed, 19 Aug 2020 09:44:31 -0400
X-MC-Unique: HHGvWZCjNWW6SPzbA91U1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8890B18BA280;
        Wed, 19 Aug 2020 13:44:30 +0000 (UTC)
Received: from [10.72.12.38] (ovpn-12-38.pek2.redhat.com [10.72.12.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 671C527BCD;
        Wed, 19 Aug 2020 13:44:28 +0000 (UTC)
Subject: Re: [PATCH] ceph: add dirs/files' opened/opening metric support
To:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200818115317.104579-1-xiubli@redhat.com>
 <7b1e716346aee082cd1ff426faf6b9bff0276ae0.camel@kernel.org>
 <CA+2bHPZoHhaEBKBKGiR6=Ui7NYnLyT-fMUYHvCcXtT2-oWXRdg@mail.gmail.com>
 <d2bb621f-5bfa-c936-b589-e13ae13cc6d9@redhat.com>
 <ec2fe8a11a0c47774fa52a1beb38ebe5fe12a68b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <38b70edc-f14e-8e8e-bc48-ea345634ea2f@redhat.com>
Date:   Wed, 19 Aug 2020 21:44:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <ec2fe8a11a0c47774fa52a1beb38ebe5fe12a68b.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/8/19 21:41, Jeff Layton wrote:
> On Wed, 2020-08-19 at 10:01 +0800, Xiubo Li wrote:
>> On 2020/8/19 4:10, Patrick Donnelly wrote:
>>> On Tue, Aug 18, 2020 at 1:05 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>> Bear in mind that if the same file has been opened several times, then
>>>> you'll get an increment for each.
>>> Having an open file count (even for the same inode) and a count of
>>> inodes opened sounds useful to me. The latter would require some kind
>>> of refcounting for each inode? Maybe that's too expensive though.
>> For the second, yes, we need one percpu refcount, which can be add in
>> ceph_get_fmode() when increasing any entry of the
>> ci->i_nr_by_mode[fmode] for the first time, to decrease it in
>> ceph_put_fmode() when the ci->i_nr_by_mode[fmode] is empty. IMO, it
>> should be okay and won't cost too much.
>>
>> Thanks
>>
>> BRs
>>
> Sure.
>
> To be clear, I'm not _really_ disputing the usefulness of these stats,
> but I think if we're going to measure stuff like this, the changelog
> needs to justify it in some way.
>
> We may find in 2-3 years that some of these are not as useful as we
> first thought, and if we don't have any of the original justification in
> the changelog for it, it's harder to determine whether removing them is
> ok.

This makes sense for me. Will add more details on the tracker and commit 
comment later.

Thanks.

>>>> Would it potentially be more useful to report the number of inodes that
>>>> have open file descriptions associated with them? It's hard for me to
>>>> know as I'm not clear on the intended use-case for this.
>>> Use-case is more information available via `fs top`.
>>>

