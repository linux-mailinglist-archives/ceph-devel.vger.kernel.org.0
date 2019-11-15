Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623BAFD27B
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Nov 2019 02:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfKOBeV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 20:34:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37061 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727121AbfKOBeU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Nov 2019 20:34:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573781659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+4oh8fNf2u80zKZMu2nQ9WKTEeMrclTstuZlyy8P44=;
        b=NusVHzqQHrHnKCCxm/CFCPWt3WfXb+2Vn4jgh05MpWI78JblLpfxStnFxd9KEfCv/62obt
        HChb+w3FdaghfGKWkJP3nAzuDT0BR84ZkrVzowPFBJq/cbxidA/W6UJys6KOwsxnU5CHS2
        lEbAlU2Nwr8D5XfQ/Nwx7td9Gcvdkh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-qdYF2qYGOgmk1fKKJLpRgg-1; Thu, 14 Nov 2019 20:34:16 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 612241802CE0;
        Fri, 15 Nov 2019 01:34:15 +0000 (UTC)
Received: from [10.72.12.58] (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 838F15D6AE;
        Fri, 15 Nov 2019 01:34:10 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: remove the extra slashes in the server path
To:     Patrick Donnelly <pdonnell@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20191114023719.25316-1-xiubli@redhat.com>
 <d92dfa711410cdef2b6f9f0dc0a0c86ad263844c.camel@kernel.org>
 <CA+2bHPZXzFXhOPioKUDi-J-jsJb+MWg958VV7aF6Z9E=WEd+kw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c8ca1102-25b8-5d5b-3af6-6b269b680450@redhat.com>
Date:   Fri, 15 Nov 2019 09:34:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CA+2bHPZXzFXhOPioKUDi-J-jsJb+MWg958VV7aF6Z9E=WEd+kw@mail.gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: qdYF2qYGOgmk1fKKJLpRgg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/15 3:30, Patrick Donnelly wrote:
> On Thu, Nov 14, 2019 at 3:35 AM Jeff Layton <jlayton@kernel.org> wrote:
>> On Wed, 2019-11-13 at 21:37 -0500, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>> Any reason not to cc ceph-devel here? Was that just an oversight, or do
>> you think this needs a security embargo?
>>
>>> When mounting if the server path has more than one slash, such as:
>>>
>>> 'mount.ceph 192.168.195.165:40176:/// /mnt/cephfs/'
>>>
>>> In the MDS server side the extra slash will be treated as snap dir,
>>> and then we can get the following debug logs:
>>>
>> It sort of sounds like the real problem is in the MDS.
>>
>> Shouldn't it just be ignoring the extra '/' characters? I'm not a huge
>> fan of adding in this complex handling to work around an MDS bug.
> Agreed! Xiubo, please create a tracker ticket.

Sure, will do it.

BRs

Xiubo



