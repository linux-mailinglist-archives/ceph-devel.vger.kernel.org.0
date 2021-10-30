Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2289444072B
	for <lists+ceph-devel@lfdr.de>; Sat, 30 Oct 2021 06:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhJ3EID (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 Oct 2021 00:08:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24250 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhJ3EH7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 00:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635566728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4j+Jdyp/OpHmJkjKTE3iVvlA682mZvQ6l1Nbv/RAKQg=;
        b=dr5GPei4u8IZKiH4H4wONwlL3iKfZYRWx9fN5L/Ag/kSh99AmyN+lbyR+mUwp1QapNrvVA
        trgDakqBrXBjzGY+dYQDy81S+Kih/gMm3nDlBcPjX3up7Or+f+9Mo/6Ckf+0daU/tfXTLu
        MndDZe0ivg/QaxFNU30Dv/tvUubM3Ro=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-j_sF41pHO6uXVKWLhJwugA-1; Sat, 30 Oct 2021 00:05:26 -0400
X-MC-Unique: j_sF41pHO6uXVKWLhJwugA-1
Received: by mail-pl1-f199.google.com with SMTP id w12-20020a170902d70c00b0014028fd6402so4741707ply.6
        for <ceph-devel@vger.kernel.org>; Fri, 29 Oct 2021 21:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4j+Jdyp/OpHmJkjKTE3iVvlA682mZvQ6l1Nbv/RAKQg=;
        b=VGQG2ssLEMDNfK6bhZ50OxrBWPzNj/KmroiOSnQ+8OV8MX+EPS/sV8uGjsERr4ufhj
         S44JzDusrlOTKS5fquJkpIR8CajOlRKNN+vcl+3bS50azBH5oSoUq4jp9DEgT6Bo/H+u
         +iWEboFtxgAVlu4EG74Dj8+lxxjy4IP9UCu8glAcP8JW7wRPdTT+Rjnkvh8p991TCeEN
         iDR7njhec5Tak3lS7yps56PhW8NW4FHFJzWfajRiUuIWk9ilXOcUFdT82c4nAs5LztTe
         hcvhv21KrMd3OZMs7gYCVbk4kKQeDB2GoWBREITFF0TXa56l19O81bXy0Thy8fycJPa8
         ljpA==
X-Gm-Message-State: AOAM5305JhJGIiViWGbxiemdaCcmPbZCxQSNImVuUwn/45S7gHsKSN2v
        QxpGYPhtzXn4XLaBAOp4Xkf6Z1XGvbdeAhPede/ifoYkVzwLwTbWH7epc+2mam3UqaZYlijJsyO
        zsz9FUXvBLmjB8z7vkrj0V8lXI90MmPz5hlXbNpHFx7ZyGyQktgqlLAxnkf7trWZv7tlE4AI=
X-Received: by 2002:a05:6a00:1781:b0:44d:faef:f2c0 with SMTP id s1-20020a056a00178100b0044dfaeff2c0mr14715259pfg.68.1635566724569;
        Fri, 29 Oct 2021 21:05:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymlfHhyIvbxQOfjXyLgtw6tDUqejjvFaVVL8HpQtObMJuu8T6zDNSt81qE7E6GrWkoxkuUEw==
X-Received: by 2002:a05:6a00:1781:b0:44d:faef:f2c0 with SMTP id s1-20020a056a00178100b0044dfaeff2c0mr14715227pfg.68.1635566724186;
        Fri, 29 Oct 2021 21:05:24 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c21sm8895804pfl.15.2021.10.29.21.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 21:05:23 -0700 (PDT)
Subject: Re: [PATCH v3 2/4] ceph: add __ceph_sync_read helper support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211028091438.21402-1-xiubli@redhat.com>
 <20211028091438.21402-3-xiubli@redhat.com>
 <c824c92834ebcb01867a4fbc4d4bb0cbce95a8ad.camel@kernel.org>
 <8fcffb2a-416d-374e-0e31-3c742bfc7f27@redhat.com>
 <009d56d0e59dee1b72492b9e10dd7f0f7e2b7512.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c851adb1-1209-a83e-900c-1abfaa2ce869@redhat.com>
Date:   Sat, 30 Oct 2021 12:05:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <009d56d0e59dee1b72492b9e10dd7f0f7e2b7512.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/29/21 6:29 PM, Jeff Layton wrote:
> On Fri, 2021-10-29 at 16:14 +0800, Xiubo Li wrote:
>> On 10/29/21 2:21 AM, Jeff Layton wrote:
>>> On Thu, 2021-10-28 at 17:14 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/file.c  | 31 +++++++++++++++++++++----------
>>>>    fs/ceph/super.h |  2 ++
>>>>    2 files changed, 23 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>> index 6e677b40410e..74db403a4c35 100644
>>>> --- a/fs/ceph/file.c
>>>> +++ b/fs/ceph/file.c
>>>> @@ -901,20 +901,17 @@ static inline void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64
>>>>     * If we get a short result from the OSD, check against i_size; we need to
>>>>     * only return a short read to the caller if we hit EOF.
>>>>     */
>>>> -static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>>> -			      int *retry_op)
>>>> +ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>>> +			 struct iov_iter *to, int *retry_op)
>>>>    {
>>>> -	struct file *file = iocb->ki_filp;
>>>> -	struct inode *inode = file_inode(file);
>>>>    	struct ceph_inode_info *ci = ceph_inode(inode);
>>>>    	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>>>    	struct ceph_osd_client *osdc = &fsc->client->osdc;
>>>>    	ssize_t ret;
>>>> -	u64 off = iocb->ki_pos;
>>>> +	u64 off = *ki_pos;
>>>>    	u64 len = iov_iter_count(to);
>>>>    
>>>> -	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>>>> -	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>>>> +	dout("sync_read on inode %p %llu~%u\n", inode, *ki_pos, (unsigned)len);
>>>>    
>>>>    	if (!len)
>>>>    		return 0;
>>>> @@ -1058,18 +1055,32 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>>>    			break;
>>>>    	}
>>>>    
>>>> -	if (off > iocb->ki_pos) {
>>>> +	if (off > *ki_pos) {
>>>>    		if (ret >= 0 &&
>>>>    		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
>>>>    			*retry_op = CHECK_EOF;
>>>> -		ret = off - iocb->ki_pos;
>>>> -		iocb->ki_pos = off;
>>>> +		ret = off - *ki_pos;
>>>> +		*ki_pos = off;
>>>>    	}
>>>>    out:
>>>>    	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);
>>>> return ret;
>>>>     	 }
>>>>    
>>>> +static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>>> +			      int *retry_op)
>>>> +{
>>>> +	struct file *file = iocb->ki_filp;
>>>> +	struct inode *inode = file_inode(file);
>>>> +
>>>> +	dout("sync_read on file %p %llu~%u %s\n", file, iocb->ki_pos,
>>>> +	     (unsigned)iov_iter_count(to),
>>>> +	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
>>>> +
>>>> +	return __ceph_sync_read(inode, &iocb->ki_pos, to, retry_op);
>>>> +
>>>> +}
>>>> +
>>>>    struct ceph_aio_request {
>>>>    	struct kiocb *iocb;
>>>>    	size_t total_len;
>>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>>> index 027d5f579ba0..57bc952c54e1 100644
>>>> --- a/fs/ceph/super.h
>>>> +++ b/fs/ceph/super.h
>>>> @@ -1235,6 +1235,8 @@ extern int ceph_renew_caps(struct inode *inode, int fmode);
>>>>    extern int ceph_open(struct inode *inode, struct file *file);
>>>>    extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>>>>    			    struct file *file, unsigned flags, umode_t mode);
>>>> +extern ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>>>> +				struct iov_iter *to, int *retry_op);
>>>>    extern int ceph_release(struct inode *inode, struct file *filp);
>>>>    extern void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>>>>    				  char *data, size_t len);
>>> I went ahead and picked this patch too since #3 had a dependency on it.
>>> If we decide we want #3 for stable though, then we probably ought to
>>> respin these to avoid it.
>> I saw you have merged these two into the testing branch, should I respin
>> for the #3 ?
>>
>>
> Yeah, it's probably worthwhile to mark this for stable. It _is_ a data
> integrity issue after all.
>
> Could you respin it so that it doesn't rely on patch #2?

Sure.


