Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58A74C42A8
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Feb 2022 11:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbiBYKnY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Feb 2022 05:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239612AbiBYKnV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Feb 2022 05:43:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C0B5182DA9
        for <ceph-devel@vger.kernel.org>; Fri, 25 Feb 2022 02:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645785768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5oTGyheUno2s04vSwyULClu8YryvvOjcLKFzVaXIKg=;
        b=VqmJhid9dK+5mWzQVpCZSOax6Tlrt/sZ6TAsz8msHpphw97E327f5C+4Y9djaaklxHMCpq
        LYE8zmAORhKjp08TFPATvo7H/pI38PbfjMgKKq+AfIiYLr1yyQz6b8IWAT2ZE4qN2/KysQ
        moTOEctWzR+WDoVHTJiHN7IFvqmhrUY=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-sIBIVi4MOkOMqHPPy-5xmQ-1; Fri, 25 Feb 2022 05:42:47 -0500
X-MC-Unique: sIBIVi4MOkOMqHPPy-5xmQ-1
Received: by mail-pf1-f197.google.com with SMTP id t134-20020a62788c000000b004e1367caccaso2905031pfc.14
        for <ceph-devel@vger.kernel.org>; Fri, 25 Feb 2022 02:42:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=g5oTGyheUno2s04vSwyULClu8YryvvOjcLKFzVaXIKg=;
        b=RvU3cvbnL/vDh7AgPy9g6OnevWb0J1BUA8u2mZKsK87SVaFaUad2E9/NZgNjEVHD+P
         XPQIMv3r2nqv+kR8rMhsrx8cBgboUFw3ZxHxCh0H3ySO0lluX9ggrCZ4dVFEjHQlU5aZ
         VSuMTC2JEUXgG3n4F8AszWBYd6XlZAu84w5ql6QzcaVifTQOxcJGZK/VnPMI9ZjasUv2
         zTqkZbUD7vgOKuw5OVVSZusOJgcMaiIo3a3Ca5kCio410adQYyGTsnp9Iog61w4br0El
         bXvcDJP8Cij7P/eD9tGmItTq4CCUco0GftuLltEKiitVyS5Jg8uWxI8p30xr1ajEK6Eo
         AcxQ==
X-Gm-Message-State: AOAM5304w/7fpgsj7fC5JNgGibDj5viB/gSHO2N3ACY7yIc8p8OwN/61
        EAtNMaNbrMsWpARlw8o2Bv8IfEsb3hNYMOGJshNvbVSUVIzjrOObcODtwK1ULQEDHgnKIs9Zgta
        raPIJXZflCop3aO8GqDHQwQ==
X-Received: by 2002:a17:902:aa8e:b0:14f:fa5e:fe80 with SMTP id d14-20020a170902aa8e00b0014ffa5efe80mr7092794plr.84.1645785766016;
        Fri, 25 Feb 2022 02:42:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHh1K22ENHRg9YZ17cthkqY7yBVP7aoUi5ueN2/uEE3PFcZ6CFJMMYMUdu0ldYdKS56z+nXw==
X-Received: by 2002:a17:902:aa8e:b0:14f:fa5e:fe80 with SMTP id d14-20020a170902aa8e00b0014ffa5efe80mr7092777plr.84.1645785765782;
        Fri, 25 Feb 2022 02:42:45 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y191-20020a6264c8000000b004e1bf2f580csm2658942pfb.78.2022.02.25.02.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 02:42:45 -0800 (PST)
Subject: Re: [RFC PATCH] ceph: add support for encrypted snapshot names
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220224112142.18052-1-lhenriques@suse.de>
 <7d2a798d-ce32-4bf7-b184-267bb79f44e3@redhat.com>
 <87h78ni8ed.fsf@brahms.olymp>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1945dae6-9c0d-4cf7-49d8-843ba15e1710@redhat.com>
Date:   Fri, 25 Feb 2022 18:42:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87h78ni8ed.fsf@brahms.olymp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/25/22 5:48 PM, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 2/24/22 7:21 PM, Luís Henriques wrote:
>>> Since filenames in encrypted directories are already encrypted and shown
>>> as a base64-encoded string when the directory is locked, snapshot names
>>> should show a similar behaviour.
>>>
>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>> ---
>>>    fs/ceph/dir.c   | 15 +++++++++++++++
>>>    fs/ceph/inode.c | 10 +++++++++-
>>>    2 files changed, 24 insertions(+), 1 deletion(-)
>>>
>>> Support on the MDS for names that'll be > MAX_NAME when base64 encoded is
>>> still TBD.  I thought it would be something easy to do, but snapshots
>>> don't seem to make use of the CDir/CDentry (which is where alternate_name
>>> is stored on the MDS).  I'm still looking into this, but I may need some
>>> help there :-(
>>>
>>> Cheers,
>>> --
>>> Luís
>>>
>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>> index a449f4a07c07..20ae600ee7cd 100644
>>> --- a/fs/ceph/dir.c
>>> +++ b/fs/ceph/dir.c
>>> @@ -1065,6 +1065,13 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>>>    		op = CEPH_MDS_OP_MKSNAP;
>>>    		dout("mksnap dir %p snap '%pd' dn %p\n", dir,
>>>    		     dentry, dentry);
>>> +		/* XXX missing support for alternate_name in snapshots */
>>> +		if (IS_ENCRYPTED(dir) && (dentry->d_name.len >= 189)) {
>>> +			dout("encrypted snapshot name too long: %pd len: %d\n",
>>> +			     dentry, dentry->d_name.len);
>>> +			err = -ENAMETOOLONG;
>>> +			goto out;
>>> +		}
>>>    	} else if (ceph_snap(dir) == CEPH_NOSNAP) {
>>>    		dout("mkdir dir %p dn %p mode 0%ho\n", dir, dentry, mode);
>>>    		op = CEPH_MDS_OP_MKDIR;
>>> @@ -1109,6 +1116,14 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>>>    	    !req->r_reply_info.head->is_target &&
>>>    	    !req->r_reply_info.head->is_dentry)
>>>    		err = ceph_handle_notrace_create(dir, dentry);
>>> +
>>> +	/*
>>> +	 * If we have created a snapshot we need to clear the cache, otherwise
>>> +	 * snapshot will show encrypted filenames in readdir.
>>> +	 */
>> Do you mean dencrypted filenames ?
> What I see without this d_drop() is that, if I run an 'ls' in a snapshot
> directory immediately after creating it, the filenames in that snapshot
> will be encrypted.  Maybe there's a bug somewhere else and this d_drop()
> isn't the right fix...?

Maybe should fix this in ceph_fill_trace() in

        } else if ((req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||... {

        }

?

I still haven't gotten where will encrypt it yet in mksnap case. Because 
the MDS will set the 'rinfo->head->is_target' but won't set the 
'rinfo->head->is_dentry', so in this case the dentry should keep the 
human readable name.

- Xiubo


> Cheers,

