Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9628A31D081
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Feb 2021 19:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhBPSyu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Feb 2021 13:54:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:44618 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhBPSys (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 16 Feb 2021 13:54:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8BF0EAE53;
        Tue, 16 Feb 2021 18:54:05 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id b64fe64e;
        Tue, 16 Feb 2021 18:55:07 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "drinkcat@chromium.org" <drinkcat@chromium.org>,
        "iant@google.com" <iant@google.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "llozano@chromium.org" <llozano@chromium.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "dchinner@redhat.com" <dchinner@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: prevent copy_file_range to copy across devices
References: <CAOQ4uxiFGjdvX2-zh5o46pn7RZhvbGHH0wpzLPuPOom91FwWeQ@mail.gmail.com>
        <20210215154317.8590-1-lhenriques@suse.de>
        <CAOQ4uxgjcCrzDkj-0ukhvHRgQ-D+A3zU5EAe0A=s1Gw2dnTJSA@mail.gmail.com>
        <73ab4951f48d69f0183548c7a82f7ae37e286d1c.camel@hammerspace.com>
        <CAOQ4uxgPtqG6eTi2AnAV4jTAaNDbeez+Xi2858mz1KLGMFntfg@mail.gmail.com>
        <92d27397479984b95883197d90318ee76995b42e.camel@hammerspace.com>
        <CAOQ4uxjUf15fDjz11pCzT3GkFmw=2ySXR_6XF-Bf-TfUwpj77Q@mail.gmail.com>
        <87r1lgjm7l.fsf@suse.de>
        <CAOQ4uxgucdN8hi=wkcvnFhBoZ=L5=ZDc7-6SwKVHYaRODdcFkg@mail.gmail.com>
        <87blckj75z.fsf@suse.de>
        <CAOQ4uxiiy_Jdi3V1ait56=zfDQRBu_5gb+UsCo8GjMZ6XRhozw@mail.gmail.com>
Date:   Tue, 16 Feb 2021 18:55:06 +0000
In-Reply-To: <CAOQ4uxiiy_Jdi3V1ait56=zfDQRBu_5gb+UsCo8GjMZ6XRhozw@mail.gmail.com>
        (Amir Goldstein's message of "Tue, 16 Feb 2021 19:44:48 +0200")
Message-ID: <874kibkflh.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Amir Goldstein <amir73il@gmail.com> writes:

> On Tue, Feb 16, 2021 at 6:41 PM Luis Henriques <lhenriques@suse.de> wrote:
>>
>> Amir Goldstein <amir73il@gmail.com> writes:
>>
>> >> Ugh.  And I guess overlayfs may have a similar problem.
>> >
>> > Not exactly.
>> > Generally speaking, overlayfs should call vfs_copy_file_range()
>> > with the flags it got from layer above, so if called from nfsd it
>> > will allow cross fs copy and when called from syscall it won't.
>> >
>> > There are some corner cases where overlayfs could benefit from
>> > COPY_FILE_SPLICE (e.g. copy from lower file to upper file), but
>> > let's leave those for now. Just leave overlayfs code as is.
>>
>> Got it, thanks for clarifying.
>>
>> >> > This is easy to solve with a flag COPY_FILE_SPLICE (or something) that
>> >> > is internal to kernel users.
>> >> >
>> >> > FWIW, you may want to look at the loop in ovl_copy_up_data()
>> >> > for improvements to nfsd_copy_file_range().
>> >> >
>> >> > We can move the check out to copy_file_range syscall:
>> >> >
>> >> >         if (flags != 0)
>> >> >                 return -EINVAL;
>> >> >
>> >> > Leave the fallback from all filesystems and check for the
>> >> > COPY_FILE_SPLICE flag inside generic_copy_file_range().
>> >>
>> >> Ok, the diff bellow is just to make sure I understood your suggestion.
>> >>
>> >> The patch will also need to:
>> >>
>> >>  - change nfs and overlayfs calls to vfs_copy_file_range() so that they
>> >>    use the new flag.
>> >>
>> >>  - check flags in generic_copy_file_checks() to make sure only valid flags
>> >>    are used (COPY_FILE_SPLICE at the moment).
>> >>
>> >> Also, where should this flag be defined?  include/uapi/linux/fs.h?
>> >
>> > Grep for REMAP_FILE_
>> > Same header file, same Documentation rst file.
>> >
>> >>
>> >> Cheers,
>> >> --
>> >> Luis
>> >>
>> >> diff --git a/fs/read_write.c b/fs/read_write.c
>> >> index 75f764b43418..341d315d2a96 100644
>> >> --- a/fs/read_write.c
>> >> +++ b/fs/read_write.c
>> >> @@ -1383,6 +1383,13 @@ ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
>> >>                                 struct file *file_out, loff_t pos_out,
>> >>                                 size_t len, unsigned int flags)
>> >>  {
>> >> +       if (!(flags & COPY_FILE_SPLICE)) {
>> >> +               if (!file_out->f_op->copy_file_range)
>> >> +                       return -EOPNOTSUPP;
>> >> +               else if (file_out->f_op->copy_file_range !=
>> >> +                        file_in->f_op->copy_file_range)
>> >> +                       return -EXDEV;
>> >> +       }
>> >
>> > That looks strange, because you are duplicating the logic in
>> > do_copy_file_range(). Maybe better:
>> >
>> > if (WARN_ON_ONCE(flags & ~COPY_FILE_SPLICE))
>> >         return -EINVAL;
>> > if (flags & COPY_FILE_SPLICE)
>> >        return do_splice_direct(file_in, &pos_in, file_out, &pos_out,
>> >                                  len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
>>
>> My initial reasoning for duplicating the logic in do_copy_file_range() was
>> to allow the generic_copy_file_range() callers to be left unmodified and
>> allow the filesystems to default to this implementation.
>>
>> With this change, I guess that the calls to generic_copy_file_range() from
>> the different filesystems can be dropped, as in my initial patch, as they
>> will always get -EINVAL.  The other option would be to set the
>> COPY_FILE_SPLICE flag in those calls, but that would get us back to the
>> problem we're trying to solve.
>
> I don't understand the problem.
>
> What exactly is wrong with the code I suggested?
> Why should any filesystem be changed?
>
> Maybe I am missing something.

Ok, I have to do a full brain reboot and start all over.

Before that, I picked the code you suggested and tested it.  I've mounted
a cephfs filesystem and used xfs_io to execute a 'copy_range' command
using /sys/kernel/debug/sched_features as source.  The result was a
0-sized file in cephfs.  And the reason is thevfs_copy_file_range()
early exit in:

	if (len == 0)
		return 0;

'len' is set in generic_copy_file_checks().

This means that we're not solving the original problem anymore (probably
since v1 of this patch, haven't checked).

Also, re-reading Trond's emails, I read: "... also disallowing the copy
from, say, an XFS formatted partition to an ext4 partition".  Isn't that
*exactly* what we're trying to do here?  I.e. _prevent_ these copies from
happening so that tracefs files can't be CFR'ed?

/me stops now and waits to see if the morning brings some sun :-)

Cheers,
-- 
Luis
